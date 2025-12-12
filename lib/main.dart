import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpapers/Pages/homescreen.dart';
import 'package:wallpapers/Pages/singlewallpaperscreen.dart';
import 'package:wallpapers/blocs/app_bar_cubit.dart';
import 'package:wallpapers/blocs/bottom_nav_cubit.dart';
import 'package:wallpapers/blocs/wallpaper_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _tryRestoreLastOpened();
  }

  Future<void> _tryRestoreLastOpened() async {
    // Wait a moment for widgets to bind and for the MaterialApp to build
    await Future.delayed(const Duration(milliseconds: 300));
    final prefs = await SharedPreferences.getInstance();
    final large = prefs.getString('last_large');
    final medium = prefs.getString('last_medium');
    if (large != null && large.isNotEmpty && _navKey.currentContext != null) {
      // Use restorablePush to restore the single wallpaper screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          Navigator.restorablePush(
            _navKey.currentContext!,
            // route builder will be resolved by the screen's static method
            SingleWallpaperScreen.routeBuilder,
            arguments: {'large': large, 'medium': medium ?? ''},
          );
          // clear saved fallback so it doesn't reopen every launch
          prefs.remove('last_large');
          prefs.remove('last_medium');
        } catch (_) {}
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => WallpaperCubit()),
        BlocProvider(create: (context) => BottomNavCubit()),
        BlocProvider(create: (context) => AppBarCubit()),
      ],
      child: MaterialApp(
        navigatorKey: _navKey,
        title: 'Wallpapers',
        debugShowCheckedModeBanner: false,
        restorationScopeId: 'app',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
