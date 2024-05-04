import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/extensions/context.dart';
import '../../../core/extensions/string.dart';
import '../models/nearby_place_model.dart';

class SearchResultWidget extends StatelessWidget {
  const SearchResultWidget({
    super.key,
    required this.places,
    required this.mapsController,
  });

  final List<Results> places;
  final GoogleMapController mapsController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        child: Wrap(
          children: places.map((e) {
            final coordinate = LatLng(
              e.geometry?.location?.lat ?? 0,
              e.geometry?.location?.lng ?? 0,
            );
            return InkWell(
              onTap: () async {
                await mapsController.showMarkerInfoWindow(
                  MarkerId('${e.placeId}'),
                );
                await mapsController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: coordinate, zoom: 15),
                  ),
                );
              },
              child: Card(
                surfaceTintColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(children: [
                    if (e.icon != null) ...[
                      Image.network(e.icon!, width: 32),
                      const SizedBox(width: 16),
                    ],
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.name ?? '',
                          style: context.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          e.vicinity ?? '',
                          style: context.textTheme.bodyMedium,
                        ),
                        Text(
                          '${e.types?.first.replaceAll('_', ' ').capitalizeEachFirstLetter}',
                          style: context.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
