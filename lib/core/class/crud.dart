import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hos/core/functions/checkinternet.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class Crud {
  // Future<Either<Statusrequest, Map>> postrequset(
  //   String linkUrl,
  //   Map data,
  // ) async {
  //   try {
  //     if (await checkinterner()) {
  //       var response = await http.post(
  //         Uri.parse(linkUrl),
  //         body: jsonEncode(data),
  //         headers: {
  //           "Content-Type":
  //               "application/json", // بتعرف السيرفر إن اللي مبعوث ده JSON مش String عادي
  //           "Accept": "application/json",
  //         },
  //       );
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         var responsebody = jsonDecode(response.body);
  //         return Right(responsebody);
  //       } else {
  //         return Left(Statusrequest.failure);
  //       }
  //     } else {
  //       return Left(Statusrequest.checkinterner);
  //     }
  //   } catch (e) {
  //     return Left(Statusrequest.serverfailure);
  //   }
  // }



Future<Either<Statusrequest, Map>> postrequset(
    String linkUrl,
    Map data,
  ) async {
    try {
      if (await checkinterner()) {
        var response = await http.post(
          Uri.parse(linkUrl),
          body: jsonEncode(data),
          headers: {
            "Content-Type": "application/json", 
            "Accept": "application/json",
          },
        );

        // 1. تحقق أولاً إذا كان السيرفر أرسل داتا بصيغة JSON (سواء نجح الطلب أو فشل مثل 429 أو 422)
        // أخطاء لاراول وعمليات الـ Rate Limit تعود دائماً بـ JSON يحتوي على حقول مثل "message" أو "status"
        if (response.body.isNotEmpty) {
          try {
            var responsebody = jsonDecode(response.body);
            
            // إذا كان السيرفر أرسل رد JSON صالح، نمرره فوراً لـ Right لكي تستطيع قراءته في الـ Controller
            // وبذلك سيتعامل الـ Controller مع الـ status: false أو الرسالة القادمة بشكل طبيعي.
            return Right(responsebody);
          } catch (jsonError) {
            // إذا لم يكن الرد JSON (مثلاً صفحة خطأ HTML من السيرفر 500) سيذهب للخطوة التالية
          }
        }

        // 2. في حال لم يكن هناك Body وكان الكود يمثل نجاحاً
        if (response.statusCode == 200 || response.statusCode == 201) {
          return Right({});
        } else {
          return Left(Statusrequest.failure);
        }

      } else {
        return Left(Statusrequest.checkinterner);
      }
    } catch (e) {
      return Left(Statusrequest.serverfailure);
    }
  }
  Future<Either<Statusrequest, Map>> getrequset(String linkUrl) async {
    try {
      if (await checkinterner()) {
        var response = await http.get(Uri.parse(linkUrl));
        print(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var responsebody = jsonDecode(response.body);
          return Right(responsebody);
        } else {
          return Left(Statusrequest.failure);
        }
      } else {
        return Left(Statusrequest.checkinterner);
      }
    } catch (e) {
      return Left(Statusrequest.serverfailure);
    }
  }

  Future<Either<Statusrequest, Map>> putandpacth(
    String linkUrl,
    Map data,
  ) async {
    try {
      if (await checkinterner()) {
        var response = await http.patch(
          Uri.parse(linkUrl),
          body: jsonEncode(data),
          headers: {
            "Content-Type":
                "application/json", // بتعرف السيرفر إن اللي مبعوث ده JSON مش String عادي
            "Accept": "application/json",
          },
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          var responsebody = jsonDecode(response.body);
          return Right(responsebody);
        } else {
          return Left(Statusrequest.failure);
        }
      } else {
        return Left(Statusrequest.checkinterner);
      }
    } catch (e) {
      return Left(Statusrequest.serverfailure);
    }
  }

  //to add file
  Future<Either<Statusrequest, Map>> addRequestWithMultipleImages(
    String method,
    String url,
    Map data,
    List<File?> images, [ // 👈 غيرناها هنا لـ List عشان تشيل الـ 3 صور
    String? namerequest,
  ]) async {
    // الاسم الافتراضي لو متبعتش، وفي حالتنا للعناصر هنمرر له "items_images[]"
    namerequest ??= "image";

    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    request.fields['_method'] = method;

    // 📁 لف على قائمة الصور وأضف الصور الصالحة (المش null) فقط
    for (var image in images) {
      if (image != null) {
        var length = await image.length();
        var stream = http.ByteStream(image.openRead());
        stream.cast();

        var multipartFile = http.MultipartFile(
          namerequest, // 👈 نفس المفتاح لكل الصور عشان اللارافل يستقبلها كـ Array
          stream,
          length,
          filename: basename(image.path),
        );
        request.files.add(multipartFile);
      }
    }

    // add Data to request
    data.forEach((key, value) {
      request.fields[key] = value
          .toString(); // تحويل القيم لنصوص لضمان عدم حدوث خطأ
    });

    // Send Request
    var myrequest = await request.send();
    var response = await http.Response.fromStream(myrequest);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map responsebody = jsonDecode(response.body);
      print(responsebody); // طباعة الرد الكامل للتأكد من البيانات المستلمة

      return Right(responsebody);
    } else {
      return const Left(Statusrequest.serverfailure);
    }
  }
  Future<Either<Statusrequest, Map>> deleterequwst(
    String linkUrl,
    Map data,
  ) async {
    try {
      if (await checkinterner()) {
        var response = await http.delete(
          Uri.parse(linkUrl),
          body: jsonEncode(data),
          headers: {
            "Content-Type":
                "application/json", // بتعرف السيرفر إن اللي مبعوث ده JSON مش String عادي
            "Accept": "application/json",
          },
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          var responsebody = jsonDecode(response.body);
          return Right(responsebody);
        } else {
          return Left(Statusrequest.failure);
        }
      } else {
        return Left(Statusrequest.checkinterner);
      }
    } catch (e) {
      return Left(Statusrequest.serverfailure);
    }
  }

}

enum Statusrequest {
  loading,
  checkinterner,
  failure,
  serverfailure,
  success,
  none,
  nodata,
}
