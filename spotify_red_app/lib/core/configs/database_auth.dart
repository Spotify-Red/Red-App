import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify_red_app/core/configs/storage_service.dart';

const String clientId = "fLhYgvfgrtzW7yGGZZegRAZ4pHCGNC1qXpSvDvewq6Vd0FXYedCvEZkLwUpdvcTuSGdUr1P9RLhV6VfkyZaBmdqwT9D4uKZT44DBHtpbheecff2tYPFKNGuZj7nJcBra";

// --- Model ---
class DatabaseUserProfile {
  final String uid;
  final String username;
  final List<String> friends;
  final int privacy;

  DatabaseUserProfile({
    required this.uid,
    required this.username,
    required this.friends,
    required this.privacy,
  });

  factory DatabaseUserProfile.fromJson(Map<String, dynamic> json) {
    return DatabaseUserProfile(
      uid: json['user'][0]['uid'] ?? 'Unknown',
      username: json['user'][0]['username'] ?? 'Unknown',
      friends: List<String>.from(json['user'][0]['friends']?.split(",") ?? []),
      privacy: json['user'][0]['privacy'] ?? 0,
    );
  }
}

class DatabaseRepository {
  Future<DatabaseUserProfile?> fetchUserProfile() async {
    String? token = await TokenStorageService().getDatabaseToken();
    String? uid = await TokenStorageService().getDatabaseUid();

    if (token == null || uid == null) {
      print("No Database Token or UID stored.");
      return null;
    }

    final response = await http.get(
      Uri.parse('http://craven.life/sp27red/api/get_user.php?code=$clientId&access_token=$token&uid=$uid'),
    );

    if (response.statusCode == 200) {
      return DatabaseUserProfile.fromJson(jsonDecode(response.body));
    } else {
      print("Failed to fetch user profile (${response.statusCode})");
      return null;
    }
  }

  Future<void> storeDatabaseAuth(String token, String uid) async {
    await TokenStorageService().setDatabaseToken(token);
    await TokenStorageService().setDatabaseUid(uid);
    print("Stored Database Token & UID!");
  }

  Future<String?> getStoredToken() async {
    return await TokenStorageService().getDatabaseToken();
  }

  Future<String?> getStoredUid() async {
    return await TokenStorageService().getDatabaseUid();
  }
}
