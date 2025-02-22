import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_red_app/common/widgets/button/basic_app_button.dart';
import 'package:spotify_red_app/core/configs/assets/app_images.dart';
import 'package:spotify_red_app/core/configs/assets/app_vectors.dart';
import 'package:spotify_red_app/core/configs/theme/app_colors.dart';
import 'package:spotify_red_app/presentation/choose_mode/pages/choose_mode.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 40
            ),
            decoration: BoxDecoration(
              
            ),
          ),
          Container(
            color: Colors.black.withAlpha(38)
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 40
            ),
            child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset(
                      AppVectors.logo
                    )
                  ),
                  Spacer(),
                  Text(
                    'Enjoy Listening to Music',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                  SizedBox(height: 21),
                  Text(
                    'Enjoy Listening to MusicEnjoy Listening to MusicEnjoy Listening to MusicEnjoy Listening to MusicEnjoy Listening to MusicEnjoy Listening to Music',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  BasicAppButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const ChooseModePage()
                        )
                      );
                    },
                    title: 'Get Started'
                  )
                ],
              ),
          ),
        ],
      )
    );
  }
}