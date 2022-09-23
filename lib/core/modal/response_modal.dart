import '../enum/api_status.dart';

class ResponseModal<T> {
  ApiStatus status;
  String message;
  T? data;

  ResponseModal.success({String? message, this.data})
      : status = ApiStatus.success,
        message = message ?? "";

  ResponseModal.error({this.status = ApiStatus.error, required this.message, this.data});
}
