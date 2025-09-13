import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/design/molecules/snackbar/ds_snackbar.dart';
import 'package:flutter/material.dart';

void handleException(Exception exception, BuildContext context) {
  if (exception is ServerException) {
    showSnackBar(context: context, message: exception.metaData.message);
  } else {
    showSnackBar(context: context, message: ErrorMessages.defaultErrorMessage);
  }
}
