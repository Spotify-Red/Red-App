import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_red_app/core/configs/assets/app_vectors.dart';
import 'package:spotify_red_app/presentation/intro/pages/get_started.dart';
import 'package:spotify_red_app/presentation/root/pages/root.dart';
import 'package:spotify_red_app/presentation/sign_in/config/spotify_auth_bloc.dart';

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
    // Delay navigation to allow splash to show.
    Future.delayed(const Duration(seconds: 2), () {
      if (!_hasRedirected) {
        // If after delay no authentication state is detected, go to GetStartedPage.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GetStartedPage()),
        );
      }
    });
  }

  void _redirectBasedOnAuthState(SpotifyAuthState state) {
    if (!_hasRedirected && (state is SpotifyTokenStored || state is SpotifyProfileLoaded)) {
      _hasRedirected = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RootPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SpotifyAuthBloc, SpotifyAuthState>(
      listener: (context, state) {
        // When the SpotifyAuthBloc state indicates authentication, redirect immediately.
        _redirectBasedOnAuthState(state);
      },
      child: Scaffold(
        body: Center(
          child: SvgPicture.asset(AppVectors.logo),
        ),
      ),
    );
  }
}
