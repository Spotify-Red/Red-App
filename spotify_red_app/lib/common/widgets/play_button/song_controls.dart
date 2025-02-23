import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:spotify_red_app/core/configs/theme/app_colors.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SongControls extends StatefulWidget {
  const SongControls({super.key});

  @override
  _SongControlsState createState() => _SongControlsState();
}

class _SongControlsState extends State<SongControls> {
  bool _isPlaying = false;
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _updatePlaybackState();
  }

  Future<void> _updatePlaybackState() async {
    try {
      final playerState = await SpotifySdk.getPlayerState();
      
      if (playerState?.track != null) {
        final imageData = await SpotifySdk.getImage(
          imageUri: playerState!.track!.imageUri,
          dimension: ImageDimension.large,
        );
        setState(() {
          _imageData = imageData;
        });
      } else {
        setState(() {
          _imageData = null;
        });
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
    // Update playback state after toggling
    _updatePlaybackState();
  }

  Future<void> _skipNext() async {
    await SpotifySdk.skipNext();
    // Update playback state after toggling
    _updatePlaybackState();
  }

  Future<void> _skipPrevious() async {
    await SpotifySdk.skipPrevious();
    // Update playback state after toggling
    _updatePlaybackState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          width: 200,
          color: Colors.grey[300],
          child: _imageData != null
            ? Image.memory(
                _imageData!,
                fit: BoxFit.cover,
              )
            : const Center(child: Text('No track playing')),
        ),
        Row(
          children: [
            IconButton(
              onPressed: _skipPrevious,
              icon: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.skip_previous,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              onPressed: _togglePlayback,
              icon: Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              onPressed: _skipNext,
              icon: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.skip_next,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ]
        ),
      ]
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