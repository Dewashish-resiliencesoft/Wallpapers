import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wallpapers/Pages/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset(
      'assets/app_splashscreen/splashscreen_fullscreen.mp4',
    );

    try {
      await _controller.initialize();
      setState(() {
        _isVideoInitialized = true;
      });

      // Play the video
      await _controller.play();

      // Listen for video completion
      _controller.addListener(() {
        if (_controller.value.position >= _controller.value.duration) {
          _navigateToHome();
        }
      });
    } catch (e) {
      // If video fails to load, navigate to home after 2 seconds
      debugPrint('Error loading splash video: $e');
      Future.delayed(const Duration(seconds: 2), _navigateToHome);
    }
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _isVideoInitialized
            ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            : const CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
