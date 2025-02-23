import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_red_app/common/widgets/button/basic_app_button.dart';
import 'package:spotify_red_app/common/widgets/play_button/song_controls.dart';
import 'package:spotify_red_app/core/configs/theme/app_colors.dart';
import 'package:spotify_red_app/presentation/sign_in/config/spotify_auth_bloc.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    connectToSpotifyRemote();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SongControls()
                    ],
                  )
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

Future<void> play() async {
  try {
    await SpotifySdk.resume();
  } on PlatformException catch (e) {
    print(e);
    //setStatus(e.code, message: e.message);
  } on MissingPluginException {
    print('MissingPluginException');
    //setStatus('not implemented');
  }
}

Future<void> pause() async {
  try {
    await SpotifySdk.pause();
  } on PlatformException catch (e) {
    print(e);
    //setStatus(e.code, message: e.message);
  } on MissingPluginException {
    print('MissingPluginException');
    //setStatus('not implemented');
  }
}

Future<void> skipNext() async {
  await SpotifySdk.skipNext();
}

Future<void> skipPrevious() async {
  await SpotifySdk.skipPrevious();
}

Future<void> connectToSpotifyRemote() async {
  try {
    var result = await SpotifySdk.connectToSpotifyRemote(
        clientId: "96ff1332017242f0b78cdbb128c3f07d",
        redirectUrl: "myapp://callback");
    print(result);
  } on PlatformException catch (e) {
    print(e);
  } on MissingPluginException {
    print('MissingPluginException');
  }
}

Future getPlayerState() async {
  try {
    return await SpotifySdk.getPlayerState();
  } on PlatformException catch (e) {
    print(e);
  } on MissingPluginException {
    print('not implemented');
  }
}