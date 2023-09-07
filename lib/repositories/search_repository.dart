import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_directions/google_maps_directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart' as direct;
import 'package:hive/models/nearby_response.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:latlong2/latlong.dart' as dis;

import '../instances/firebase_instances.dart';

class SearchRepository {
  static Future<List<Marker>> getNearbyPlaces(String fastFoodName) async {
    String latitude = '10.2524';
    String longitude = '123.8392';
    String googleApiKey = "AIzaSyDNQDYD_Gf_z1nyammhkEPwOBeP_fP6VYc";

    List<Marker> listMarkers = [];

    // Position _currentUserPosition = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);

    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=2000&types=restaurant&name=$fastFoodName&key=$googleApiKey');

    var response = await http.post(url);
    String lat = '';
    String lang = '';

    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    String imgurl =
        "https://cdn.iconscout.com/icon/free/png-256/free-fast-food-location-4596379-3813390.png?f=webp";
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgurl)).load(imgurl))
        .buffer
        .asUint8List();

    String imgurlMyLocation = "https://www.fluttercampus.com/img/car.png";
    Uint8List bytesMyLocation =
        (await NetworkAssetBundle(Uri.parse(imgurlMyLocation))
                .load(imgurlMyLocation))
            .buffer
            .asUint8List();

    PolylinePoints polylinePoints = PolylinePoints();

    double totalDistance = 0;

    List<LatLng> polylineCoordinates = [];
    List<double> distanceKilometers = [];

    for (int i = 0; i < nearbyPlacesResponse.results!.length; i++) {
      lat = nearbyPlacesResponse.results![i].geometry!.location!.lat.toString();
      lang =
          nearbyPlacesResponse.results![i].geometry!.location!.lng.toString();
      String markerID = nearbyPlacesResponse.results![i].reference.toString();
      String name = nearbyPlacesResponse.results![i].name.toString();

      //var distance = dis.Distance();

      // final km = distance.as(
      //     dis.LengthUnit.Kilometer,
      //     dis.LatLng(10.2524, 123.8392),
      //     dis.LatLng(double.parse(lat), double.parse(lang)));

      // DistanceValue distanceBetween = await distance(
      //     10.2524, 123.8392, double.parse(lat), double.parse(lang),
      //     googleAPIKey: googleApiKey);

      // String textInKmOrMeters = distanceBetween.text;

      // DurationValue durationBetween = await duration(
      //     10.2524, 123.8392, double.parse(lat), double.parse(lang),
      //     googleAPIKey: googleApiKey);

      // String durationInMinutesOrHours = durationBetween.text;

      // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      //   googleApiKey,
      //   PointLatLng(10.2524, 123.8392),
      //   PointLatLng(double.parse(lat), double.parse(lang)),
      // );

      // for (var point in result.points) {
      //   polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      // }
      // addPolyLine(polylineCoordinates, markerID);

      var _distanceInMeters = await Geolocator.distanceBetween(
          10.2524, 123.8392, double.parse(lat), double.parse(lang));

      double distanceKm = _distanceInMeters / 1000;

      distanceKilometers.add(distanceKm);

      nearbyPlacesResponse.results?[i].distanceKilometer = distanceKm;

      listMarkers.add(
        Marker(
          markerId: MarkerId(markerID),
          position: LatLng(double.parse(lat), double.parse(lang)),
          infoWindow: InfoWindow(
            title: name,
            snippet: '${distanceKm.toStringAsFixed(1)} km ',
          ),
          icon: BitmapDescriptor.fromBytes(bytes),
        ),
      );
    }

    //User Location
    listMarkers.add(
      Marker(
        markerId: const MarkerId('user'),
        position: const LatLng(10.2524, 123.8392),
        //_currentUserPosition.latitude, _currentUserPosition.longitude,
        infoWindow: const InfoWindow(
          title: 'Love',
          snippet: 'Your Current Location',
        ),
        icon: BitmapDescriptor.fromBytes(bytesMyLocation),
      ),
    );

    return listMarkers;
  }

  static Future<List<Marker>> userMarker() async {
    List<Marker> markers = [];
    String imgUrlMyLocation = 'https://www.fluttercampus.com/img/car.png';
    Uint8List bytesMyLocation =
        (await NetworkAssetBundle(Uri.parse(imgUrlMyLocation))
                .load(imgUrlMyLocation))
            .buffer
            .asUint8List();
    markers.add(
      Marker(
        markerId: const MarkerId('user'),
        position: const LatLng(10.2524, 123.8392),
        //_currentUserPosition.latitude, _currentUserPosition.longitude,
        infoWindow: const InfoWindow(
          title: 'Love',
          snippet: 'Your Current Location',
        ),
        icon: BitmapDescriptor.fromBytes(bytesMyLocation),
      ),
    );

    return markers;
  }

  static addPolyLine(List<LatLng> polylineCoordinates, String markerId) {
    List<Polyline> polyline = [];
    PolylineId id = PolylineId(markerId);
    polyline.add(Polyline(
      polylineId: id,
      jointType: JointType.bevel,
      color: Colors.red,
      points: polylineCoordinates,
      width: 4,
    ));
    polylines = polyline;
  }

  static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  static Future<Uint8List> getBytesFromAsset() async {
    ByteData data = await rootBundle.load(
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFgPXSseJMeom-Vg66Q_x4SMswWfq2PEAGmQ&usqp=CAU');
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: 50);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
