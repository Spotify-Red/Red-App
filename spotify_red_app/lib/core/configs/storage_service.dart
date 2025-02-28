import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageService {
  static final TokenStorageService _instance = TokenStorageService._internal();
  factory TokenStorageService() => _instance;

  TokenStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> setSpotifyToken(String token) async {
    await _storage.write(key: 'spotify_token', value: token);
  }

  Future<String?> getSpotifyToken() async {
    return await _storage.read(key: 'spotify_token');
  }

  Future<void> setSpotifyUid(String uid) async {
    await _storage.write(key: 'spotify_uid', value: uid);
  }

  Future<String?> getSpotifyUid() async {
    return await _storage.read(key: 'spotify_uid');
  }

  Future<void> setDatabaseToken(String token) async {
    await _storage.write(key: 'database_token', value: token);
  }

  Future<String?> getDatabaseToken() async {
    return await _storage.read(key: 'database_token');
  }

  Future<void> setDatabaseUid(String uid) async {
    await _storage.write(key: 'database_uid', value: uid);
  }

  Future<String?> getDatabaseUid() async {
    return await _storage.read(key: 'database_uid');
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
