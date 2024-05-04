import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/services/local_storage_service.dart';
import 'core/services/navigation_service.dart';
import 'features/maps/providers/map_provider.dart';
import 'features/maps/views/map_page.dart';

GetIt getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingleton(LocalStorageService(), signalsReady: true);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MapProvider()),
    ],
    child: MaterialApp(
      title: 'Zavod-IT Test',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: GoogleFonts.roboto().fontFamily,
        textTheme: GoogleFonts.robotoTextTheme(),
        bottomSheetTheme:
            const BottomSheetThemeData(surfaceTintColor: Colors.white),
      ),
      home: const MapPage(),
    ),
  ));
}
