import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:spotify_red_app/core/configs/theme/app_colors.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SongControls extends StatefulWidget {
  const SongControls({super.key});

  static _SongControlsState? _songControlsState;

  static void updatePlayback() async {
    await _songControlsState?._updatePlaybackState();
  }

  @override
  _SongControlsState createState() {
    _songControlsState = _SongControlsState();
    return _songControlsState!;
  }
}

class _SongControlsState extends State<SongControls> {
  bool _isPlaying = false;
  Uint8List? _imageData;
  late List _trackData;

  @override
  void initState() {
    super.initState();
    _updatePlaybackState();
  }

  Future<void> _updatePlaybackState() async {
    try {
      final playerState = await SpotifySdk.getPlayerState();
      
      if (playerState?.track != null) {
        final trackTitle = playerState!.track!.name;
        final trackArtist = playerState.track!.artists.firstOrNull?.name;
        final trackAlbum = playerState.track!.album.name;
        final imageData = await SpotifySdk.getImage(
          imageUri: playerState!.track!.imageUri,
          dimension: ImageDimension.large,
        );
        setState(() {
          _imageData = imageData;
          _trackData = [trackTitle, trackArtist, trackAlbum];
        });
        setState(() {
          _isPlaying = !playerState.isPaused;
        });
      } else {
        setState(() {
          _imageData = null;
          _trackData = ["","",""];
        });
      }
    } catch (e) {
      print("Error fetching player state: $e");
    }
  }

  Future<void> _playPauseSong() async {
    try {
      final playerState = await SpotifySdk.getPlayerState();

      if(_imageData == null) {
        _updatePlaybackState();
      }

      setState(() {
        _isPlaying = !playerState!.isPaused;
      });
    } catch (e) {
      print("Error fetching player state: $e");
    }
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await SpotifySdk.pause();
    } else {
      await SpotifySdk.resume();
    }
    _playPauseSong();
  }

  Future<void> _skipNext() async {
    await SpotifySdk.skipNext();
    _updatePlaybackState();
  }

  Future<void> _skipPrevious() async {
    await SpotifySdk.skipPrevious();
    _updatePlaybackState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black
          ),
          bottom: BorderSide(
            color: Colors.black
          ),
        )
      ),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 79,
            width: 79,
            color: Colors.grey[300],
            child: _imageData != null
                ? Image.memory(
                    _imageData!,
                    fit: BoxFit.cover,
                  )
                : const Center(child: Text('No track playing')),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _imageData != null
                    ? SizedBox(
                        width: double.infinity,
                        child: Text(
                          _trackData[0].toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Title",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _skipPrevious,
                      icon: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.skip_previous,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _togglePlayback,
                      icon: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _skipNext,
                      icon: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.skip_next,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> isPlaying() async {
  try {
    PlayerState? playerState = await SpotifySdk.getPlayerState();
    bool isPlaying = !playerState!.isPaused;
    return isPlaying;
  } catch (e) {
    print("Error fetching player state: $e");
    return false;
  }
}