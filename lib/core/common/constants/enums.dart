enum ServerExceptionType {
  unknown,
  apiError,
  receiveTimeout,
  requestTimeout,
  badRequest,
  connectionTimeout,
  signInFailure,
  sseError,
  fileUploadError,
}

enum FileType {
  pdf,
  doc,
  txt,
  unknown,
}
