import 'package:flutter_svg/svg.dart';
import 'package:spotify_red_app/common/widgets/appbar/app_bar.dart';
import 'package:spotify_red_app/common/widgets/button/basic_app_button.dart';
import 'package:spotify_red_app/core/configs/assets/app_vectors.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 30
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BasicAppButton(
              onPressed: () async {
                await SpotifySdk.connectToSpotifyRemote(clientId: "96ff1332017242f0b78cdbb128c3f07d", redirectUrl: "myapp://callback");
              },
              title: "Sign In"
            )
          ],
        ),
      ),
    );
  }
}