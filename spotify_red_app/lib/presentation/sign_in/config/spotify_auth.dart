import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:http/http.dart' as http;

const clientId = "96ff1332017242f0b78cdbb128c3f07d";
const clientSecret = "7d43ec22766f424099850d08cd519502";
const redirectUri = "http://localhost:53403";
const authUrl = "https://accounts.spotify.com/authorize";
const tokenUrl = "https://accounts.spotify.com/api/token";

StreamSubscription? _sub;

Future<void> authenticateWithSpotify(BuildContext context) async {
  final url =
      "$authUrl?client_id=$clientId&response_type=code&redirect_uri=$redirectUri&scope=user-read-private%20user-read-email";

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "Could not launch $url";
  }
}


void initUniLinks(BuildContext context) {
  _sub = uriLinkStream.listen((Uri? uri) {
    if (uri != null && uri.queryParameters.containsKey('code')) {
      final code = uri.queryParameters['code'];
      getAccessToken(code!);
    }
  });
}

Future<void> getAccessToken(String code) async {
  final response = await http.post(
    Uri.parse(tokenUrl),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret')),
    },
    body: {
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': redirectUri,
    },
  );

  final responseData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    final accessToken = responseData['access_token'];
    print("Access Token: $accessToken");
  } else {
    print("Error: ${responseData['error_description']}");
  }
}


Future<void> fetchUserProfile(String accessToken) async {
  final response = await http.get(
    Uri.parse("https://api.spotify.com/v1/me"),
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    final profile = jsonDecode(response.body);
    print("User Profile: ${profile['display_name']}");
  } else {
    print("Error fetching profile: ${response.body}");
  }
}

Future<void> refreshAccessToken(String refreshToken) async {
  final response = await http.post(
    Uri.parse(tokenUrl),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
    },
    body: {
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
    },
  );

  final responseData = jsonDecode(response.body);

  if (response.statusCode == 200) {
    final newAccessToken = responseData['access_token'];
    print("New Access Token: $newAccessToken");
  } else {
    print("Error refreshing token: ${response.body}");
  }
}
