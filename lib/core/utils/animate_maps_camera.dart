import 'package:google_maps_flutter/google_maps_flutter.dart';

void animateMapsCamera(GoogleMapController mapsController, LatLng coordinate) {
  mapsController.animateCamera(
    CameraUpdate.newCameraPosition(
      CameraPosition(target: coordinate, zoom: 15),
    ),
  );
}
