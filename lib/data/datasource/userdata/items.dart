import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Itemsdata {
  Crud crud;
  Itemsdata(this.crud);

  // ✳️ أضفنا {int? page} كـ معامل اختياري في نهاية الدالة
  postdata(String id, {int? page}) async {
    // إذا تم تمرير رقم الصفحة، نقوم بدمجه في الرابط، وإلا يظل الرابط كما هو
    String url = page != null ? "${LinkApi.items}?page=$page" : LinkApi.items;

    var response = await crud.postrequset(
      url, // ✳️ نمرر الرابط الديناميكي الجديد هنا
      {"category_id": id},
    );
    return response.fold((l) => l, (r) => r);
  }
}
