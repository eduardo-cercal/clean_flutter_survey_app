import 'package:flutter/material.dart';
import 'package:get/get.dart';


mixin SessionManager {
  void handleSession({
    required BuildContext context,
    required Stream<bool?> stream,
  }) {
    stream.listen(
      (isExpired) {
        if (isExpired != null && isExpired) {
          Get.offAllNamed('/login');
        }
      },
    );
  }
}
