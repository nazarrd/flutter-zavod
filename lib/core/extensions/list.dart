import 'package:google_maps_flutter/google_maps_flutter.dart';

extension StringExtension on List {
  LatLng get firstCoordinate {
    return LatLng(
      first.geometry?.location?.lat ?? 0,
      first.geometry?.location?.lng ?? 0,
    );
  }
}
