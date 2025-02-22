import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () { final result = launchUrl(Uri.https(
            "accounts.spotify.com",
            "/authorize",
            {
              "client_id": "96ff1332017242f0b78cdbb128c3f07d",
              "response_type": "code",
              "redirect_uri": "myapp://callback",
              "scope": "user-read-private user-read-email",
              "show_dialog": "true"
            }
            ));
            },
          child: const Text("Connect to Spotify"),
        ),
      ),
    );
  }
}
