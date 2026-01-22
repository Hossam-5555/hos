  import 'dart:convert';
import 'dart:ui';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http show post;

Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();



  Getpolyline(currentlat, currentlong, destlat, destlong) async {
    String Url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${currentlat},${currentlong}&destination=${destlat},${destlong}&key=YOUR_GOOGLE";
    final response = await http.post(Uri.parse(Url));

    var responsebody = jsonDecode(response.body);

    var point = responsebody["routes"][0]["overview_polyline"]["points"];
    List<PointLatLng> result = polylinePoints.decodePolyline(point);
    if (result.isNotEmpty) {
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
  }