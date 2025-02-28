import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_red_app/common/widgets/appbar/app_bar.dart';
import 'package:spotify_red_app/common/widgets/button/basic_app_button.dart';
import 'package:spotify_red_app/core/configs/assets/app_vectors.dart';
import 'package:spotify_red_app/core/configs/database_api.dart';
import 'package:spotify_red_app/core/configs/storage_service.dart';
import 'package:spotify_red_app/presentation/root/pages/root.dart';
import 'package:spotify_red_app/core/configs/database_auth.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:http/http.dart' as http;

class SigninPageSpotify extends StatelessWidget {
  const SigninPageSpotify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: BasicAppButton(
            onPressed: () async {
              try {
                final spotifyToken = await SpotifySdk.getAccessToken(
                  clientId: "96ff1332017242f0b78cdbb128c3f07d",
                  redirectUrl: "myapp://callback",
                  scope: "app-remote-control, user-modify-playback-state, playlist-read-private, user-top-read, playlist-modify-private, user-library-modify, user-library-read",
                );
        
                final profile = await http.get(
                  Uri.parse('https://api.spotify.com/v1/me'),
                  headers: {'Authorization': 'Bearer $spotifyToken'},
                );
        
                String uid = jsonDecode(profile.body)['id'].toString();
        
                await TokenStorageService().setSpotifyToken(spotifyToken);
                await TokenStorageService().setSpotifyUid(uid);
        
                var dbUserResponse = await DatabaseAPI.getUser();
                if (dbUserResponse == null || dbUserResponse.toString().contains("User not found")) {
                  await DatabaseAPI.createUser(uid, uid);
                }
        
                final databaseToken = await DatabaseAPI.getAccessToken();
                if (databaseToken != null) {
                  await TokenStorageService().setDatabaseToken(databaseToken);
                  await TokenStorageService().setDatabaseUid(uid);
                }
        
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const RootPage()),
                );
              } catch (e) {
                debugPrint("Error during sign-in: $e");
              }
            },
            title: "Link to Spotify",
          ),
        ),
      ),
    );
  }
}
