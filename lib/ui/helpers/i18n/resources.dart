import 'package:clean_flutter_login_app/ui/helpers/i18n/strings/en_us.dart';
import 'package:clean_flutter_login_app/ui/helpers/i18n/strings/pt_br.dart';
import 'package:clean_flutter_login_app/ui/helpers/i18n/strings/translations.dart';
import 'package:flutter/widgets.dart';

class R {
  static Translation strings = PtBr();

  static void load(Locale locale) {
    switch (locale.toString()) {
      case 'en_US':
        strings = EnUs();
        break;
      default:
        strings = PtBr();
        break;
    }
  }
}
