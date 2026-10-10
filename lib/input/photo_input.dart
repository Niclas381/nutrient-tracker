/// Camera capture for meal and label photos. Photos are compressed to about 1600 px on the long edge.
library;

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PhotoInput {
  final ImagePicker _picker = ImagePicker();

  static const longEdge = 1600.0;

  /// Takes a photo (or picks one from the gallery) and returns the path of the JPEG stored in the app's
  /// documents folder as `photos/<name>.jpg`, or null when cancelled.
  Future<String?> capture(String name, {bool fromGallery = false}) async {
    final shot = await _picker.pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      maxWidth: longEdge,
      maxHeight: longEdge,
      imageQuality: 85,
    );
    if (shot == null) return null;
    final dir = Directory(p.join((await getApplicationDocumentsDirectory()).path, 'photos'));
    await dir.create(recursive: true);
    final target = p.join(dir.path, '$name.jpg');
    await File(shot.path).copy(target);
    return target;
  }
}
