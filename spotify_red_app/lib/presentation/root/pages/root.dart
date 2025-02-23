import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_red_app/presentation/sign_in/config/spotify_auth_bloc.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Spotify Profile")),
      body: BlocBuilder<SpotifyAuthBloc, SpotifyAuthState>(
        builder: (context, state) {
          if (state is SpotifyProfileLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Name: ${state.profile.displayName}"),
                  Text("Email: ${state.profile.email}"),
                ],
              ),
            );
          } else if (state is SpotifyAuthError) {
            return Center(child: Text("Error: ${state.error}"));
          } else if (state is SpotifyTokenStored) {
            // Token stored; waiting for profile to load.
            return const Center(child: Text("Fetching profile..."));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
