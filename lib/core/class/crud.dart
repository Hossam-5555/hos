import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hos/core/functions/checkinternet.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

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

  Future<Either<Statusrequest, Map>> getrequset(
    String linkUrl,
  ) async {
    try {
      if (await checkinterner()) {
        var response = await http.get(Uri.parse(linkUrl));

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
  Future<Either<Statusrequest, Map>> addRequestWithImageOne(
    String url,
    Map data,
    File? image, [
    String? namerequest,
  ]) async {
    namerequest ??= "files";

    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    // request.headers.addAll();

    if (image != null) {
      var length = await image.length();
      var stream = http.ByteStream(image.openRead());
      stream.cast();
      var multipartFile = http.MultipartFile(
        namerequest,
        stream,
        length,
        filename: basename(image.path),
      );
      request.files.add(multipartFile);
    }

    // add Data to request
    data.forEach((key, value) {
      request.fields[key] = value;
    });
    // add Data to request
    // Send Request
    var myrequest = await request.send();
    // For get Response Body
    var response = await http.Response.fromStream(myrequest);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map responsebody = jsonDecode(response.body);
      return Right(responsebody);
    } else {
      return const Left(Statusrequest.serverfailure);
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
