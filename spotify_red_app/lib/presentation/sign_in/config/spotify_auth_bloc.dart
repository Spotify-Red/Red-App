import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_red_app/core/configs/storage_service.dart';

// --- Bloc Events ---
abstract class SpotifyAuthEvent {}

class SetSpotifyToken extends SpotifyAuthEvent {
  final String token;
  SetSpotifyToken(this.token);
}

// --- Bloc States ---
abstract class SpotifyAuthState {}

class SpotifyAuthInitial extends SpotifyAuthState {}

class SpotifyTokenStored extends SpotifyAuthState {
  final String token;
  SpotifyTokenStored(this.token);
}

class SpotifyAuthError extends SpotifyAuthState {
  final String error;
  SpotifyAuthError(this.error);
}

// --- Bloc Implementation ---
class SpotifyAuthBloc extends Bloc<SpotifyAuthEvent, SpotifyAuthState> {
  SpotifyAuthBloc() : super(SpotifyAuthInitial()) {
    on<SetSpotifyToken>((event, emit) async {
      try {
        await TokenStorageService().setSpotifyToken(event.token);
        emit(SpotifyTokenStored(event.token));
      } catch (e) {
        emit(SpotifyAuthError(e.toString()));
      }
    });
  }
}
