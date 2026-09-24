import 'dart:convert';
import 'dart:ui';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http show post;


// ignore: strict_top_level_inference
Future<Set<Polyline>> getpolyline(currentlat, currentlong, destlat, destlong) async {
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Polyline> polylines = {};


  // ignore: non_constant_identifier_names
  String Url =
      "https://maps.googleapis.com/maps/api/directions/json?origin=$currentlat,$currentlong&destination=$destlat,$destlong&key=YOUR_GOOGLE";
  final response = await http.post(Uri.parse(Url));

  var responsebody = jsonDecode(response.body);

  var point = responsebody["routes"][0]["overview_polyline"]["points"];
  List<PointLatLng> result = polylinePoints.decodePolyline(point);
  if (result.isNotEmpty) {
    // ignore: avoid_function_literals_in_foreach_calls, non_constant_identifier_names
    result.forEach((PointLatLng PointLatLng) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });
  }
  Polyline polyline = Polyline(
    polylineId: PolylineId("polyline_id"),
    color: Color(0xff0000ff),
    width: 5,
    points: polylineCoordinates,
  );

  polylines.add(polyline);
  return polylines;
}
