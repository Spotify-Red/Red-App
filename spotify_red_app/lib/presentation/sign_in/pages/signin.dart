import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_red_app/presentation/root/pages/root.dart';
import 'package:spotify_red_app/presentation/sign_in/config/spotify_auth_bloc.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SigninPageSpotify extends StatelessWidget {
  const SigninPageSpotify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign in to Spotify")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              // Trigger the auth flow to get the access token.
              final token = await SpotifySdk.getAccessToken(
                clientId: "96ff1332017242f0b78cdbb128c3f07d",
                redirectUrl: "myapp://callback",
                scope: "app-remote-control, user-modify-playback-state, playlist-read-private",
              );

              // Store the token in the bloc.
              context.read<SpotifyAuthBloc>().add(SetSpotifyToken(token));
              // Navigate to the root page.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RootPage()),
              );
                        } catch (e) {
              debugPrint("Error obtaining token: $e");
            }
          },
          child: const Text("Sign In"),
        ),
      ),
    );
  }
}
