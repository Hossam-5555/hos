import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:hos/core/functions/checkinternet.dart';
import 'package:http/http.dart' as http;

class Crud {
  Future<Either<Statusrequest, Map>> postrequset(
    String linkUrl,
    Map data,
  ) async {
    try {
      if (await checkinterner()) {
        var response = await http.post(Uri.parse(linkUrl), body: data);

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
}
