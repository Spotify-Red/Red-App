import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_red_app/common/helpers/is_dark.dart';
import 'package:spotify_red_app/common/widgets/appbar/app_bar.dart';
import 'package:spotify_red_app/common/widgets/play_button/song_controls.dart';
import 'package:spotify_red_app/core/configs/assets/app_vectors.dart';
import 'package:spotify_red_app/core/configs/theme/app_colors.dart';
import 'package:spotify_red_app/presentation/sign_in/config/spotify_auth_bloc.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:http/http.dart' as http;

class RootPage extends StatefulWidget {
  const RootPage({super.key});
  
  @override
  State<StatefulWidget> createState() => Root();
}

class Root extends State<RootPage> {
  int currentPageIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    connectToSpotifyRemote();
    return Scaffold(
      bottomNavigationBar: _navBar(),
      appBar: BasicAppbar(
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
        ),
      ),
      body: <Widget>[
        // FEED ==============================================================
        BlocBuilder<SpotifyAuthBloc, SpotifyAuthState>(
        builder: (context, state) {
          if (state is SpotifyProfileLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
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

      // LIBRARY ==============================================================
      BlocBuilder<SpotifyAuthBloc, SpotifyAuthState>(
        builder: (context, state) {
          if (state is SpotifyProfileLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SongControls()
                    ],
                  ),
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

      // PROFILE ==============================================================
      BlocBuilder<SpotifyAuthBloc, SpotifyAuthState>(
        builder: (context, state) {
          if (state is SpotifyProfileLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: state.profile.image != 'Unknown' ? Image.network(
                      state.profile.image,
                      fit: BoxFit.fill,
                      width: 200,
                    ) : Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.isDarkMode ? Colors.white.withAlpha(50) : Colors.black.withAlpha(50),
                      ),
                      width: 200,
                      child: Text(
                        state.profile.displayName[0],
                        style: TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      )
                    ),
                  ),                  
                  Text(state.profile.displayName),
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
      ][currentPageIndex]
    );
  }

  @override
  Widget _navBar() {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      indicatorColor: AppColors.primary,
      selectedIndex: currentPageIndex,
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home, color: !context.isDarkMode ? Colors.white : Colors.white),
          icon: Icon(Icons.home),
          label: 'Feed',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.library_music, color: !context.isDarkMode ? Colors.white : Colors.white),
          icon: Icon(Icons.library_music),
          label: 'Library',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.portrait_rounded, color: !context.isDarkMode ? Colors.white : Colors.white),
          icon: Icon(Icons.portrait_rounded),
          label: 'Profile',
        ),
      ],
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