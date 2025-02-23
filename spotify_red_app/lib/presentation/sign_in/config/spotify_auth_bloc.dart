import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:http/http.dart' as http;

// --- Model ---
class SpotifyUserProfile {
  final String displayName;
  final String externalURLs;
  final int followers;
  final String href;
  final String id;
  final String image;
  final String type;
  final String uri;

  SpotifyUserProfile({
    required this.displayName,
    required this.externalURLs,
    required this.followers,
    required this.href,
    required this.id,
    required this.image,
    required this.type,
    required this.uri,
  });

  factory SpotifyUserProfile.fromJson(Map<String, dynamic> json) {
    return SpotifyUserProfile(
      displayName: json['display_name'] ?? 'Unknown',
      externalURLs: json['external_urls']['spotify'] ?? 'Unknown',
      followers: json['followers']['total'] ?? 0,
      href: json['href'] ?? 'Unknown',
      id: json['id'] ?? 'Unknown',
      image: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]['url'] ?? 'Unknown'
          : 'Unknown',
      type: json['type'] ?? 'Unknown',
      uri: json['uri'] ?? 'Unknown',
    );
  }
}

// --- Repository ---
class SpotifyRepository {
  Future<SpotifyUserProfile> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return SpotifyUserProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }
}

// --- Bloc Events ---
abstract class SpotifyAuthEvent {}

class SetSpotifyToken extends SpotifyAuthEvent {
  final String token;
  SetSpotifyToken(this.token);
}

class FetchUserProfile extends SpotifyAuthEvent {}

// --- Bloc States ---
abstract class SpotifyAuthState {}

class SpotifyAuthInitial extends SpotifyAuthState {}

class SpotifyTokenStored extends SpotifyAuthState {
  final String token;
  SpotifyTokenStored(this.token);
}

class SpotifyProfileLoaded extends SpotifyAuthState {
  final SpotifyUserProfile profile;
  SpotifyProfileLoaded(this.profile);
}

class SpotifyAuthError extends SpotifyAuthState {
  final String error;
  SpotifyAuthError(this.error);
}

// --- Bloc Implementation using HydratedBloc ---
class SpotifyAuthBloc extends HydratedBloc<SpotifyAuthEvent, SpotifyAuthState> {
  final SpotifyRepository repository;
  String? _token;

  SpotifyAuthBloc({required this.repository}) : super(SpotifyAuthInitial()) {
    on<SetSpotifyToken>((event, emit) {
      _token = event.token;
      emit(SpotifyTokenStored(event.token));
      add(FetchUserProfile());
    });

    on<FetchUserProfile>((event, emit) async {
      if (_token != null) {
        try {
          final profile = await repository.fetchUserProfile(_token!);
          emit(SpotifyProfileLoaded(profile));
        } catch (e) {
          emit(SpotifyAuthError(e.toString()));
        }
      }
    });
  }

  // Public getter for the stored token
  String? get storedToken => _token;

  @override
  SpotifyAuthState? fromJson(Map<String, dynamic> json) {
    try {
      final token = json['token'] as String?;
      if (token != null) {
        _token = token;
        return SpotifyTokenStored(token);
      }
      return SpotifyAuthInitial();
    } catch (_) {
      return SpotifyAuthInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(SpotifyAuthState state) {
    if (_token != null) {
      return {'token': _token};
    }
    return null;
  }
}
