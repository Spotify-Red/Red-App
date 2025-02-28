import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_red_app/core/configs/assets/app_vectors.dart';
import 'package:spotify_red_app/core/configs/storage_service.dart';
import 'package:spotify_red_app/presentation/intro/pages/get_started.dart';
import 'package:spotify_red_app/presentation/root/pages/root.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _hasRedirected = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () async {
      await _checkAuthStatus();
    });
  }

  Future<void> _checkAuthStatus() async {
    String? token = await TokenStorageService().getSpotifyToken();

    if (!_hasRedirected) {
      _hasRedirected = true;
      if (token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RootPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GetStartedPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(AppVectors.logo),
      ),
    );
  }
}
