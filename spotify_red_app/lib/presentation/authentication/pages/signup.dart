import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_red_app/common/helpers/is_dark.dart';
import 'package:spotify_red_app/common/widgets/appbar/app_bar.dart';
import 'package:spotify_red_app/common/widgets/button/basic_app_button.dart';
import 'package:spotify_red_app/core/configs/assets/app_vectors.dart';
import 'package:spotify_red_app/presentation/authentication/pages/signin.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _signinText(context),
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
            _registerText(),
            SizedBox(height: 50),
            _fullNameField(context),
            SizedBox(height: 20),
            _emailField(context),
            SizedBox(height: 20),
            _passwordField(context),
            SizedBox(height: 20),
            BasicAppButton(
              onPressed: (){},
              title: "Create Account"
            )
          ],
        ),
      ),
    );
  }
  
  Widget _registerText() {
    return const Text(
      'Register',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _fullNameField(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Full Name',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Enter Email',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Enter Password',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme
      ),
    );
  }
  
  Widget _signinText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 50
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Do you have an account? ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: context.isDarkMode ? Colors.white : Colors.black
            ),
          ),
          TextButton(
            onPressed: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const SigninPage()
                  )
                );
              },
            child: Text(
              'Sign In'
            )
          )
        ],
      ),
    );
  }
}