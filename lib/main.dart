import 'dart:async';
import 'dart:io';
import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:digivity_admin_app/Authentication/appRouter.dart';
import 'package:digivity_admin_app/Authentication/firebase_options.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Helpers/NotificationCounter.dart';
import 'package:digivity_admin_app/Providers/DashboardProvider.dart';
import 'package:digivity_admin_app/Providers/MenuProvider.dart';
import 'package:digivity_admin_app/Providers/StaffDataProvider.dart';
import 'package:digivity_admin_app/Providers/StudentAttendanceProvider.dart';
import 'package:digivity_admin_app/Providers/StudentDataProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  // Ensure Flutter binding is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Set up global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  // Add crash protection wrapper
  runZonedGuarded(
    () async {
      try {
        // Initialize Firebase
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        debugPrint("Firebase Initialized Successfully");
      } catch (e, stackTrace) {
        debugPrint("Firebase Initialization Failed: $e");
        debugPrint("Stack trace: $stackTrace");
      }

      try {
        final notificationService = NotificationService();
        await notificationService.init();
      } catch (e, stackTrace) {
        debugPrint("Firebase Initialization Failed: $e");
        debugPrint("Stack trace: $stackTrace");
      }
      // Initialize path provider explicitly to catch issues early
      try {
        await getApplicationDocumentsDirectory();
        debugPrint("Path provider initialized successfully");
      } catch (e, stackTrace) {
        debugPrint("Path provider initialization failed: $e");
        debugPrint("Stack trace: $stackTrace");
      }

      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UiThemeProvider()),
            ChangeNotifierProvider(create: (_) => DashboardProvider()),
            ChangeNotifierProvider(create: (_) => StudentDataProvider()),
            ChangeNotifierProvider(create: (_) => StaffDataProvider()),
            ChangeNotifierProvider(create: (_) => StudentAttendanceProvider()),
            ChangeNotifierProvider(create: (_) => MenuProvider()),
            ChangeNotifierProvider.value(value: NotificationService()),
          ],
          child: const MyApp(),
        ),
      );
    },
    (error, stackTrace) {
      debugPrint('Uncaught error: $error');
      debugPrint('Stack trace: $stackTrace');
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
