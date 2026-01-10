import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zuritrails/services/journey_service.dart';
import 'package:zuritrails/services/memory_service.dart';
import 'package:zuritrails/services/achievement_service.dart';
import 'package:zuritrails/services/trip_service.dart';
import 'package:zuritrails/services/wishlist_service.dart';
import 'package:zuritrails/services/visit_tracking_service.dart';
import 'package:zuritrails/services/offline_save_service.dart';
import 'package:zuritrails/utils/app_theme.dart';
import 'package:zuritrails/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiOverlayStyle);

  // Initialize services
  final journeyService = JourneyService();
  final memoryService = MemoryService();
  final achievementService = AchievementService();
  final tripService = TripService();
  final wishlistService = WishlistService();
  final visitTrackingService = VisitTrackingService();
  final offlineSaveService = OfflineSaveService();

  try {
    await journeyService.initialize();
    await memoryService.initialize();
    await achievementService.initialize();

    // Initialize new services (Phase 2)
    await tripService.initialize(journeyService: journeyService);
    await wishlistService.initialize();
    await visitTrackingService.initialize(
      journeyService: journeyService,
      tripService: tripService,
    );
    await offlineSaveService.initialize();
  } catch (e) {
    debugPrint('Error initializing services: $e');
  }

  runApp(ZuriTrailsApp(
    journeyService: journeyService,
    memoryService: memoryService,
    achievementService: achievementService,
    tripService: tripService,
    wishlistService: wishlistService,
    visitTrackingService: visitTrackingService,
    offlineSaveService: offlineSaveService,
  ));
}

class ZuriTrailsApp extends StatelessWidget {
  final JourneyService journeyService;
  final MemoryService memoryService;
  final AchievementService achievementService;
  final TripService tripService;
  final WishlistService wishlistService;
  final VisitTrackingService visitTrackingService;
  final OfflineSaveService offlineSaveService;

  const ZuriTrailsApp({
    super.key,
    required this.journeyService,
    required this.memoryService,
    required this.achievementService,
    required this.tripService,
    required this.wishlistService,
    required this.visitTrackingService,
    required this.offlineSaveService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: journeyService),
        ChangeNotifierProvider.value(value: memoryService),
        ChangeNotifierProvider.value(value: achievementService),
        // New services (Phase 2)
        ChangeNotifierProvider.value(value: tripService),
        ChangeNotifierProvider.value(value: wishlistService),
        ChangeNotifierProvider.value(value: visitTrackingService),
        ChangeNotifierProvider.value(value: offlineSaveService),
      ],
      child: MaterialApp.router(
        title: 'ZuriTrails',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
