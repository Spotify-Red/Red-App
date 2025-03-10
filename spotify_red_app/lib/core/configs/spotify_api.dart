import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify_red_app/common/widgets/play_button/song_controls.dart';
import 'package:spotify_red_app/core/configs/database_api.dart';
import 'package:spotify_red_app/core/configs/storage_service.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SpotifyAPI {
  static const String baseUrl = "https://api.spotify.com/v1";
  static const String clientId = "96ff1332017242f0b78cdbb128c3f07d";

  static Future<String?> _getStoredToken() async {
    return await TokenStorageService().getSpotifyToken();
  }

  static Future<String?> _getStoredUid() async {
    return await TokenStorageService().getSpotifyUid();
  }

  static Future<Map<String, dynamic>?> getPlaylists([String? username]) async {
    final accessToken = await _getStoredToken();
    var uri;

    if(username != null) {
      if (accessToken == null) {
        print("No access token or UID stored.");
        return null;
      }

      final uid = (await DatabaseAPI.getUser(username))?['uid'].toString;

      uri = Uri.parse("$baseUrl/me/users/$uid/playlists");
    } else {
      uri = Uri.parse("$baseUrl/me/playlists");
    }

    try {
      final response = await http.get(uri,
        headers: {'Authorization': 'Bearer $accessToken'}
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch user (${response.statusCode})");
      }
    } catch (e) {
      print("Error in getPlaylists: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> playMusic(String uri) async {
    await SpotifySdk.play(spotifyUri: uri);
    SongControls.updatePlayback();
  }
}