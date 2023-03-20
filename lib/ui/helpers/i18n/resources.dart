import 'package:clean_flutter_login_app/ui/helpers/i18n/strings/pt_br.dart';
import 'package:clean_flutter_login_app/ui/helpers/i18n/strings/translations.dart';
import 'package:flutter/widgets.dart';

class R {
  static Translation strings = PtBr();

  static void load(Locale locale) {
    switch (locale.toString()) {
      default:
        strings = PtBr();
        break;
    }
  }
}
