import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify_red_app/core/configs/storage_service.dart';

class DatabaseAPI {
  static const String baseUrl = "http://craven.life/sp27red/api";
  static const String clientId = "fLhYgvfgrtzW7yGGZZegRAZ4pHCGNC1qXpSvDvewq6Vd0FXYedCvEZkLwUpdvcTuSGdUr1P9RLhV6VfkyZaBmdqwT9D4uKZT44DBHtpbheecff2tYPFKNGuZj7nJcBra";

  static Future<String?> _getStoredToken() async {
    return await TokenStorageService().getDatabaseToken();
  }

  static Future<String?> _getStoredUid() async {
    return await TokenStorageService().getDatabaseUid();
  }

  static Future<String?> getAccessToken({String? uid}) async {
    final uri = Uri.parse("$baseUrl/get_access_token.php?code=$clientId${uid != null ? "&uid=$uid" : ""}");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['access_token'];
      } else {
        throw Exception("Failed to fetch access token (${response.statusCode})");
      }
    } catch (e) {
      print("Error in getAccessToken: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final accessToken = await _getStoredToken();
    final uid = await _getStoredUid();
    if (accessToken == null || uid == null) {
      print("No access token or UID stored.");
      return null;
    }

    final uri = Uri.parse("$baseUrl/get_user.php?code=$clientId&access_token=$accessToken&uid=$uid");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch user (${response.statusCode})");
      }
    } catch (e) {
      print("Error in getUser: $e");
      return null;
    }
  }

  static Future<bool> createUser(String uid, String username) async {
    final accessToken = await _getStoredToken();
    if (accessToken == null) return false;

    final uri = Uri.parse("$baseUrl/create_user.php?code=$clientId&access_token=$accessToken&uid=$uid&username=$username");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == "success";
      } else {
        throw Exception("Failed to create user (${response.statusCode}) ${response.body}");
      }
    } catch (e) {
      print("Error in createUser: $e");
      return false;
    }
  }

  static Future<bool> createFriendRequest(String toUid, String fromUid) async {
    final accessToken = await _getStoredToken();
    if (accessToken == null) return false;

    final uri = Uri.parse("$baseUrl/create_friend_request.php?code=$clientId&access_token=$accessToken&touid=$toUid&fromuid=$fromUid");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == "success";
      } else {
        throw Exception("Failed to send friend request (${response.statusCode})");
      }
    } catch (e) {
      print("Error in createFriendRequest: $e");
      return false;
    }
  }

  static Future<bool> respondFriendRequest(String toUid, String fromUid, String responseAction) async {
    final accessToken = await _getStoredToken();
    if (accessToken == null) return false;

    final uri = Uri.parse("$baseUrl/respond_friend_request.php?code=$clientId&access_token=$accessToken&touid=$toUid&fromuid=$fromUid&action=$responseAction");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == "success";
      } else {
        throw Exception("Failed to respond to friend request (${response.statusCode})");
      }
    } catch (e) {
      print("Error in respondFriendRequest: $e");
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>?> getFriendRequests() async {
    final accessToken = await _getStoredToken();
    final uid = await _getStoredUid();
    if (accessToken == null || uid == null) return null;

    final uri = Uri.parse("$baseUrl/get_friend_requests.php?code=$clientId&access_token=$accessToken&uid=$uid");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['requests']);
      } else {
        throw Exception("Failed to fetch friend requests (${response.statusCode})");
      }
    } catch (e) {
      print("Error in getFriendRequests: $e");
      return null;
    }
  }
}
