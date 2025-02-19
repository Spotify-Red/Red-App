import 'package:flutter/material.dart';
import 'package:spotify_red_app/common/widgets/button/basic_app_button.dart';
import 'package:spotify_red_app/presentation/sign_in/config/spotify_auth.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  Future<void> _handleSpotifyAuth() async {
    setState(() {
      _isLoading = true; // Show loading state
    });

    try {
      await authenticateWithSpotify(context);
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Spotify Connected Successfully!")),
      );
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication Failed: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _isLoading
                ? const CircularProgressIndicator() // Show loading indicator
                : BasicAppButton(
                    onPressed: _handleSpotifyAuth,
                    title: 'Connect to Spotify',
                  ),
          ),
        ],
      ),
    );
  }
}
