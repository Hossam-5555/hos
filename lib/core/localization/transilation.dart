import 'package:get/get.dart';

class Mytransilation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    "ar": {
      "1": "اختر اللغه",
      '2': 'متابعه',
      "3": "الفئات",
      "4": "عناصر جدد",

      //orderpage
      "5": "طلب رقم ",
      "6": " الدفع",
      "7": "الحاله",
      "8":"الاجمالي  "

      //orderpage
    },

    "en": {
      "1": " Choose language",
      '2': 'continue',
      '3': "Categories",
      "4": "New Items",
      //orderpage
      "5": " order numper: ",
      "6": " payment buy",
      "7": "Status",
      "8":"total price"

      //orderpage
    },
  };
}
