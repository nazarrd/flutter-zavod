import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/components/dialog/progress_dialog.dart';
import '../../../core/components/dialog/snack_bar.dart';
import '../../../core/constants/api_path.dart';
import '../../../core/network/repository.dart';
import '../models/nearby_place_model.dart';

class MapProvider with ChangeNotifier {
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return true;
    } else {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (permission == LocationPermission.deniedForever) {
          await Geolocator.openLocationSettings();
        }
        return false;
      } else {
        return true;
      }
    }
  }

  Future<Position> getPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<List<Results>> getNearbyPlace(Position? position,
      {String? keyword}) async {
    try {
      if (keyword != null) progressDialog();
      final response = await Repository.apiRequest(
        path: APIPath.findPlace,
        queryParameters: {
          "key": "YOUR-GOOGLE-MAP-API-KEY",
          "location": "${position?.latitude},${position?.longitude}",
          "radius": keyword != null ? 50000 : 5000,
          "type": "store",
          if (keyword != null) "keyword": keyword,
        },
      );
      if (response.statusCode == 200) {
        final data = NearbyPlaceModel.fromJson(response.data);
        final places = data.results ?? [];
        if (places.isEmpty) {
          showSnackBar(
            text: 'No place found',
            type: SnackBarType.warning,
          );
        }
        return places;
      } else {
        onError(response);
      }
    } catch (error, stackTrace) {
      onCatchError('nearbySearch', error, stackTrace);
    } finally {
      if (keyword != null) progressDialog(close: true);
    }
    return [];
  }
}
