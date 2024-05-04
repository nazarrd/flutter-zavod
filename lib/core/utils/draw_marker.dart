import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/maps/models/nearby_place_model.dart';
import '../components/dialog/base_dialog.dart';
import '../extensions/context.dart';
import '../extensions/string.dart';

Set<Marker> drawMarker(
  BuildContext context, {
  required GoogleMapController mapsController,
  List<Results> places = const <Results>[],
  int? length,
}) {
  Set<Marker> markers = {};
  for (final e in (length == null ? places : places.take(7))) {
    final location = e.geometry?.location ?? Location(lat: 0, lng: 0);
    markers.add(Marker(
      markerId: MarkerId('${e.placeId}'),
      position: LatLng(location.lat!, location.lng!),
      icon: BitmapDescriptor.defaultMarker,
      consumeTapEvents: true,
      infoWindow: InfoWindow(
        title: e.name,
        snippet: e.vicinity,
        onTap: () => launchUrl(
          Uri.parse(
              'https://www.google.com/maps/?q=${location.lat},${location.lng}&z=21'),
          mode: LaunchMode.inAppWebView,
        ),
      ),
      onTap: () async {
        final coordinate = LatLng(
          e.geometry?.location?.lat ?? 0,
          e.geometry?.location?.lng ?? 0,
        );

        await mapsController.showMarkerInfoWindow(MarkerId('${e.placeId}'));
        await mapsController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: coordinate, zoom: 15)));

        baseDialog(
          context,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                if (e.icon != null) ...[
                  Image.network(e.icon!, width: 20),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    e.name ?? 'Place Details',
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 12),
              ...[
                (
                  icon: Icons.star,
                  title: '${e.rating} (${e.userRatingsTotal} rating)',
                ),
                (
                  icon: Icons.location_city,
                  title: e.vicinity,
                ),
                (
                  icon: Icons.category_rounded,
                  title: e.types
                      ?.join(', ')
                      .replaceAll('_', ' ')
                      .capitalizeEachFirstLetter,
                ),
              ].map((e) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(e.icon, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${e.title}',
                        style: context.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      launchUrl(
                        Uri.parse(
                            'https://www.google.com/maps/?q=${coordinate.latitude},${coordinate.longitude}&z=21'),
                        mode: LaunchMode.inAppWebView,
                      );
                    },
                    child: Text(
                      'See Direction',
                      style: context.textTheme.titleSmall?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: context.textTheme.titleSmall?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ));
  }
  return markers;
}
