import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/loading_dialog.dart';

mixin NavigationManager {
  void handleNavigation({
    required BuildContext context,
    required Stream<String?>? stream,
    bool clear = false,
  }) {
    stream?.listen((page) {
      if (page != null && page.isNotEmpty) {
        if (clear) {
          Get.offAllNamed(page);
        } else {
          Get.toNamed(page);
        }
      }
    });
  }
}
