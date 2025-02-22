import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_red_app/common/helpers/is_dark.dart';
import 'package:spotify_red_app/common/widgets/button/basic_app_button.dart';
import 'package:spotify_red_app/core/configs/assets/app_vectors.dart';
import 'package:spotify_red_app/presentation/authentication/pages/signup_or_signin.dart';
import 'package:spotify_red_app/presentation/choose_mode/bloc/theme_cubit.dart';

class ChooseModePage extends StatelessWidget {
  const ChooseModePage({super.key});

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
            /*decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  AppImages.chooseModeBG
                )
              )
            ),*/
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
                    'Choose Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                  SizedBox(height: 21),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<ThemeCubit>().updateTheme(ThemeMode.dark);
                            },
                            child: ClipOval(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xff30393C).withAlpha(12),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      context.read<ThemeCubit>().updateTheme(ThemeMode.dark);
                                    },
                                    icon: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: context.isDarkMode ? Colors.white.withAlpha(8) : Colors.black.withAlpha(9),
                                        shape: BoxShape.circle
                                      ),
                                      child: Icon(
                                        Icons.nightlight_round,
                                        size: 15,
                                        color: context.isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    )
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Dark Mode',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 40),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<ThemeCubit>().updateTheme(ThemeMode.light);
                            },
                            child: ClipOval(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xff30393C).withAlpha(12),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      context.read<ThemeCubit>().updateTheme(ThemeMode.light);
                                    },
                                    icon: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: context.isDarkMode ? Colors.white.withAlpha(8) : Colors.black.withAlpha(9),
                                        shape: BoxShape.circle
                                      ),
                                      child: Icon(
                                        Icons.sunny,
                                        size: 15,
                                        color: context.isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    )
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Light Mode',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  BasicAppButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const SignupOrSigninPage()
                        )
                      );
                    },
                    title: 'Continue'
                  )
                ],
              ),
          ),
        ],
      )
    );
  }
}