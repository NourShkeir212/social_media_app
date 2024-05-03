import 'package:get/get.dart';

import 'ar_lang.dart';
import 'en_lang.dart';


class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': en,
    'ar': ar,
  };
}