import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_red_app/common/widgets/button/basic_app_button.dart';
import 'package:spotify_red_app/presentation/sign_in/config/spotify_auth_bloc.dart';
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
                  BasicAppButton(onPressed: play, title: 'Play'),
                  BasicAppButton(onPressed: pause, title: 'Pause')
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