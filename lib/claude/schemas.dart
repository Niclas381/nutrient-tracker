/// Validation of request and result JSON against routine_repo/schemas/ (bundled as assets).
library;

import 'package:json_schema/json_schema.dart';

class SchemaValidator {
  SchemaValidator({required String requestSchema, required String resultSchema})
      : _request = JsonSchema.create(requestSchema),
        _result = JsonSchema.create(resultSchema);

  final JsonSchema _request;
  final JsonSchema _result;

  /// Returns the list of problems; empty when valid.
  List<String> validateRequest(Map<String, dynamic> json) =>
      _request.validate(json).errors.map((e) => e.toString()).toList();

  List<String> validateResult(Object? json) => _result.validate(json).errors.map((e) => e.toString()).toList();
}
