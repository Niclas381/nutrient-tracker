import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../input/photo_input.dart';
import '../../input/voice_input.dart';
import '../../nutrition/status_answers.dart';
import '../format.dart';
import '../pages/barcode_page.dart';
import '../providers.dart';
import '../theme.dart';
import 'entry_widgets.dart';

/// Processing cards, local replies and the chat bar. [logAt] (calendar) places new entries on a past day.
class ChatPanel extends ConsumerWidget {
  const ChatPanel({super.key, this.maxHeightFraction = 0.4});

  final double maxHeightFraction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final requests = ref.watch(chatRequestsProvider).value ?? const [];
    final messages = ref.watch(chatMessagesProvider);
    final items = <(DateTime, Widget)>[
      for (final r in requests) (r.createdAt, RequestCard(request: r)),
      for (final m in messages) (m.time, MessageBubble(message: m)),
    ]..sort((a, b) => a.$1.compareTo(b.$1));

    return Column(mainAxisSize: MainAxisSize.min, children: [
      if (items.isNotEmpty)
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * maxHeightFraction),
          child: ListView.separated(
            shrinkWrap: true,
            reverse: true,
            padding: EdgeInsets.all(t.spaceS),
            itemCount: items.length,
            separatorBuilder: (_, _) => SizedBox(height: t.spaceS),
            itemBuilder: (_, i) => items[items.length - 1 - i].$2,
          ),
        ),
      const ChatBar(),
    ]);
  }
}

class MessageBubble extends ConsumerWidget {
  const MessageBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    return Align(
      alignment: message.fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(t.cardPadding),
        decoration: BoxDecoration(
          color: message.fromUser ? t.userBubble : t.replyBubble,
          borderRadius: BorderRadius.circular(t.cardRadius),
        ),
        child: Text(message.text),
      ),
    );
  }
}

class RequestCard extends ConsumerWidget {
  const RequestCard({super.key, required this.request});

  final RequestRow request;

  bool get _isPlan =>
      ((jsonDecode(request.payload) as Map)['payload'] as Map)['purpose'] == 'supplement_plan';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final text = Theme.of(context).textTheme;
    final services = ref.read(servicesProvider);
    final status = request.status;
    final processing = status == 'queued' || status == 'uploaded' || status == 'fired';

    final statusText = switch (status) {
      'queued' => services.hasBackend ? 'Sending…' : 'Waiting: routine connection not set up (Settings)',
      'uploaded' => 'Starting the routine…',
      'fired' => 'Processing…',
      _ => null,
    };

    return Card(
      child: Padding(
        padding: EdgeInsets.all(t.cardPadding),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Icon(inputSourceIcons[request.inputSource] ?? Icons.chat_bubble_outline),
            SizedBox(width: t.spaceS),
            Expanded(child: Text(request.rawInput ?? '', style: text.bodyMedium)),
            Text(timeFmt.format(request.createdAt), style: text.bodySmall?.copyWith(color: t.mutedText)),
            if (!processing)
              IconButton(
                tooltip: 'Dismiss',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close),
                onPressed: () => services.requests.dismiss(request.id),
              ),
          ]),
          if (processing) ...[
            SizedBox(height: t.spaceS),
            const LinearProgressIndicator(),
            SizedBox(height: t.spaceXs),
            Text(statusText!, style: text.bodySmall?.copyWith(color: t.mutedText)),
            if (request.lastError != null)
              Text(request.lastError!, style: text.bodySmall?.copyWith(color: t.warning)),
          ],
          if (status == 'failed') ...[
            SizedBox(height: t.spaceS),
            Text(request.lastError ?? 'Failed', style: text.bodySmall?.copyWith(color: t.error)),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonal(
                onPressed: () => services.requests.retry(request.id),
                child: const Text('Retry'),
              ),
            ),
          ],
          if (status == 'done') ...[
            if (_isPlan)
              Padding(
                padding: EdgeInsets.only(top: t.spaceS),
                child: const Text('Added to your daily supplements (Settings → Supplements).'),
              )
            else
              _Entries(requestId: request.id),
            if (request.resultNote != null)
              Padding(
                padding: EdgeInsets.only(top: t.spaceXs),
                child: Text(request.resultNote!, style: text.bodySmall?.copyWith(color: t.mutedText)),
              ),
          ],
        ]),
      ),
    );
  }
}

class _Entries extends ConsumerWidget {
  const _Entries({required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(requestEntriesProvider(requestId)).value ?? const [];
    if (entries.isEmpty) return const SizedBox.shrink();
    return Column(children: [for (final e in entries) EntryTile(entry: e)]);
  }
}

class ChatBar extends ConsumerStatefulWidget {
  const ChatBar({super.key});

  @override
  ConsumerState<ChatBar> createState() => _ChatBarState();
}

class _ChatBarState extends ConsumerState<ChatBar> {
  final _text = TextEditingController();
  final _voice = VoiceInput();
  final _photo = PhotoInput();
  bool _listening = false;
  bool _fromVoice = false;
  bool _lastWasStatus = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final input = _text.text.trim();
    if (input.isEmpty) return;
    final services = ref.read(servicesProvider);
    final chat = ref.read(chatMessagesProvider.notifier);
    final source = _fromVoice ? 'voice' : 'text';
    _text.clear();
    _fromVoice = false;

    final intent = classifyChatInput(input, previousWasStatus: _lastWasStatus);
    switch (intent) {
      case StatusIntent(:final period):
        _lastWasStatus = true;
        chat.add(ChatMessage(time: DateTime.now(), text: input, fromUser: true));
        final report = await services.nutrition.report(days: period.days);
        chat.add(ChatMessage(
            time: DateTime.now(), text: report == null ? 'Set up your profile first.' : statusAnswer(report, period), fromUser: false));
      case OutOfScopeIntent():
        _lastWasStatus = false;
        chat.add(ChatMessage(time: DateTime.now(), text: input, fromUser: true));
        chat.add(ChatMessage(time: DateTime.now(), text: outOfScopeReply, fromUser: false));
      case LogIntent():
        _lastWasStatus = false;
        await services.requests.logText(input, inputSource: source);
    }
  }

  Future<void> _toggleVoice() async {
    if (_listening) {
      await _voice.stop();
      setState(() => _listening = false);
      return;
    }
    final ok = await _voice.start(
      onText: (s) => setState(() {
        _text.text = s;
        _fromVoice = true;
      }),
      onDone: () => setState(() => _listening = false),
    );
    if (!ok && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Speech recognition is not available.')));
      return;
    }
    setState(() => _listening = true);
  }

  Future<void> _picture(String action) async {
    if (action == 'barcode') {
      await scanAndLogBarcode(context, ref);
      return;
    }
    final services = ref.read(servicesProvider);
    final id = services.requests.newId();
    final path = await _photo.capture(id, fromGallery: action == 'gallery');
    if (path == null) return;
    final caption = _text.text.trim();
    _text.clear();
    await services.requests.logPhoto(id, path, caption: caption.isEmpty ? null : caption);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(t.spaceS, t.spaceXs, t.spaceS, t.spaceS),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _text,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              decoration: const InputDecoration(hintText: 'What did you eat or drink?'),
            ),
          ),
          IconButton(
            tooltip: _listening ? 'Stop' : 'Voice memo',
            icon: Icon(_listening ? Icons.stop_circle_outlined : Icons.mic_none),
            onPressed: _toggleVoice,
          ),
          PopupMenuButton<String>(
            tooltip: 'Picture',
            icon: const Icon(Icons.photo_camera_outlined),
            onSelected: _picture,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'camera', child: Text('Photo of food')),
              PopupMenuItem(value: 'gallery', child: Text('Photo from gallery')),
              PopupMenuItem(value: 'barcode', child: Text('Scan barcode')),
            ],
          ),
          IconButton(tooltip: 'Send', icon: const Icon(Icons.send), onPressed: _send),
        ]),
      ),
    );
  }
}
