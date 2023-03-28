import 'package:clean_flutter_login_app/ui/helpers/errors/ui_error.dart';
import 'package:flutter/material.dart';

import '../components/loading_dialog.dart';
import '../components/snack_bar_error.dart';

mixin UiErrorManager {
  void handleMainError({
    required BuildContext context,
    required Stream<UiError?>? stream,
  }) {
    stream?.listen((error) {
      if (error != null) {
        snackBarError(context: context, error: error.description);
      }
    });
  }
}
