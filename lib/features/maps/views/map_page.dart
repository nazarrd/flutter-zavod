import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/components/drawer/drawer_menu.dart';
import '../../../core/components/feedback/error_feedback.dart';
import '../../../core/components/pageview/intrinsic_height_scroll_view.dart';
import '../../../core/constants/asset_path.dart';
import '../../../core/extensions/list.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/utils/animate_maps_camera.dart';
import '../../../core/utils/bytes_from_asset.dart';
import '../../../core/utils/draw_marker.dart';
import '../../../core/utils/value_notifier.dart';
import '../../../main.dart';
import '../../profile/models/user_model.dart';
import '../models/nearby_place_model.dart';
import '../providers/map_provider.dart';
import '../widgets/search_result_widget.dart';
import '../widgets/top_menu_widget.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;
  bool isLoading = true;
  late MapProvider provider;
  late GoogleMapController mapsController;
  final _controller = Completer<GoogleMapController>();
  final searchController = TextEditingController();
  Position? position;
  LatLng? latLng;
  Set<Marker> markers = {};
  List<Results> nearbyPlace = [];
  List<Results> searchPlace = [];
  Uint8List? markerIcon;

  @override
  void initState() {
    final data = getIt<LocalStorageService>().getString('userData');
    if (data != null) updateUserDataValue(UserModel.fromJson(jsonDecode(data)));

    WidgetsBinding.instance
      ..addObserver(this)
      ..addPostFrameCallback((_) async {
        markerIcon = await getBytesFromAsset(AssetPath.user, 100);
        provider = context.read<MapProvider>();
        final isGranted = await provider.requestPermission();
        if (isGranted) {
          position = await provider.getPosition();
          latLng = LatLng(position?.latitude ?? 0, position?.longitude ?? 0);

          // find nearby place
          nearbyPlace = await provider.getNearbyPlace(position);
        }
        setState(() => isLoading = false);

        // auto show user location info window after 2 seconds
        Future.delayed(const Duration(seconds: 3)).then((_) async =>
            await mapsController
                .showMarkerInfoWindow(const MarkerId('myLocation')));
      });
    super.initState();
  }

  @override
  void dispose() {
    mapsController.dispose();
    searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        debugPrint('appLifecycleState inactive');
        break;
      case AppLifecycleState.resumed:
        // ignore: deprecated_member_use
        if (!isLoading) mapsController.setMapStyle("[]");
        debugPrint('appLifecycleState resumed');
        break;
      case AppLifecycleState.paused:
        debugPrint('appLifecycleState paused');
        break;
      case AppLifecycleState.detached:
        debugPrint('appLifecycleState detached');
        break;
      case AppLifecycleState.hidden:
        debugPrint('appLifecycleState hidden');
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  void onMapCreated(GoogleMapController controller) async {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
      mapsController = controller;
      setState(() {
        markers = drawMarker(
          context,
          places: nearbyPlace,
          mapsController: mapsController,
          length: 7,
        );
        markers.add(Marker(
          markerId: const MarkerId('myLocation'),
          position: latLng!,
          icon: BitmapDescriptor.fromBytes(markerIcon!),
          consumeTapEvents: true,
          infoWindow: InfoWindow(
            title: 'My Location',
            snippet:
                '${latLng?.latitude.toStringAsFixed(8)},${latLng?.longitude.toStringAsFixed(8)}',
          ),
          onTap: () async {
            await mapsController
                .showMarkerInfoWindow(const MarkerId('myLocation'));
            await mapsController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: latLng!, zoom: 13)));
          },
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const DrawerMenu(),
      body: Builder(builder: (context) {
        if (isLoading) {
          return ErrorFeedback(
            icon: AssetPath.loadingGIF,
            iconHeight: 75,
            subtitle:
                'We are still searching for your location, please wait a few seconds.',
          );
        }

        if (position == null) {
          return const ErrorFeedback(
            title: 'Map Error',
            subtitle:
                'Failed to get user position, please allow location access permission and try again.',
          );
        }

        return IntrinsicHeightScrollView(
          child: Stack(alignment: Alignment.topCenter, children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: latLng!, zoom: 13),
              mapType: MapType.normal,
              myLocationEnabled: false,
              compassEnabled: true,
              markers: markers,
              onMapCreated: onMapCreated,
            ),
            ValueListenableBuilder<UserModel?>(
                valueListenable: userDataNotifier,
                builder: (context, data, child) {
                  return TopMenuWidget(
                    searchController: searchController,
                    onTap: () {
                      if (searchController.text.isNotEmpty) {
                        searchController.clear();
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (nearbyPlace.isNotEmpty) {
                          setState(() {
                            searchPlace.clear();
                            markers = drawMarker(
                              context,
                              places: nearbyPlace,
                              mapsController: mapsController,
                              length: 7,
                            );
                          });
                          animateMapsCamera(
                            mapsController,
                            nearbyPlace.firstCoordinate,
                          );
                        }
                      }
                    },
                    onSubmitted: (value) async {
                      if (data?.saveHistory == true) {
                        getIt<LocalStorageService>()
                            .setList('searchHistory', value);
                      }
                      searchPlace = await provider.getNearbyPlace(
                        position,
                        keyword: value,
                      );
                      if (searchPlace.isNotEmpty) {
                        setState(() {
                          markers = drawMarker(
                            context,
                            places: searchPlace,
                            mapsController: mapsController,
                          );
                        });
                        animateMapsCamera(
                          mapsController,
                          searchPlace.firstCoordinate,
                        );
                      }
                    },
                  );
                }),
            if (searchPlace.isNotEmpty)
              SearchResultWidget(
                places: searchPlace,
                mapsController: mapsController,
              ),
          ]),
        );
      }),
    );
  }
}
