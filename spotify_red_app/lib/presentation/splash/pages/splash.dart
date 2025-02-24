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
    // Check the current state of SpotifyAuthBloc on first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<SpotifyAuthBloc>().state;
      _redirectBasedOnAuthState(state);
    });

    // Delay navigation to allow splash to show.
    Future.delayed(const Duration(seconds: 2), () {
      if (!_hasRedirected) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GetStartedPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RootPage()),
      );
      }
    });
  }

  void _redirectBasedOnAuthState(SpotifyAuthState state) {
    print("Checking state: ${state}");
    if (!_hasRedirected &&
        (state is SpotifyTokenStored || state is SpotifyProfileLoaded)) {
      _hasRedirected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SpotifyAuthBloc, SpotifyAuthState>(
      listener: (context, state) {
        print("Bloc state changed: $state");
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
