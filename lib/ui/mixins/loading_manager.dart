import 'package:flutter/material.dart';

import '../components/loading_dialog.dart';

mixin LoadingManager {
  void handleLoading({
    required BuildContext context,
    required Stream<bool>? stream,
  }) {
    stream?.listen((isLoading) {
      if (isLoading) {
        loadingDialog(context);
      } else {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      }
    });
  }
}
