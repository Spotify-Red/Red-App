import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:spotify_red_app/common/widgets/button/basic_app_button.dart';
import 'package:spotify_red_app/core/configs/database_api.dart';
import 'package:spotify_red_app/core/configs/theme/app_colors.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SongControls extends StatefulWidget {
  final VoidCallback? onReviewPressed;
  const SongControls({super.key, this.onReviewPressed});

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
        final trackUID = playerState.track!.uri;
        final imageData = await SpotifySdk.getImage(
          imageUri: playerState!.track!.imageUri,
          dimension: ImageDimension.large,
        );
        setState(() {
          _imageData = imageData;
          _trackData = [trackTitle, trackArtist, trackAlbum, trackUID];
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
    try {
      if (_isPlaying) {
        await SpotifySdk.pause();
      } else {
        await SpotifySdk.resume();
      }
      _playPauseSong();
    } catch (e){
      var result = await SpotifySdk.connectToSpotifyRemote(
        clientId: "96ff1332017242f0b78cdbb128c3f07d",
        redirectUrl: "myapp://callback");
      if (_isPlaying) {
        await SpotifySdk.pause();
      } else {
        await SpotifySdk.resume();
      }
      _playPauseSong();
    }
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
    return SizedBox(
      height: 100,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black),
            bottom: BorderSide(color: Colors.black),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
        ),
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
                        onPressed: () {
                          if (_trackData.length >= 4) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ReviewsPage(
                                  title: _trackData[0] ?? 'Unknown Title',
                                  artist: _trackData[1] ?? 'Unknown Artist',
                                  album: _trackData[2] ?? 'Unknown Album',
                                  URI: _trackData[3] ?? 'Unknown URI'
                                ),
                              ),
                            );
                          }
                        },
                        icon: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.reviews,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
      ),
    );
  }
}

class ReviewsPage extends StatelessWidget {
  final String title;
  final String artist;
  final String album;
  final String URI;

  const ReviewsPage({
    super.key,
    required this.title,
    required this.artist,
    required this.album,
    required this.URI
  });

  @override
  Widget build(BuildContext context) {
    var body = TextEditingController();
    var rating = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text('Review $title')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: $title'),
            Text('Artist: $artist'),
            Text('Album: $album'),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 80,),
                Expanded(child: TextField(controller: rating)),
                SizedBox(width: 20),
                Text("/ 5", style: TextStyle(fontSize: 40),),
                SizedBox(width: 80,),
              ],
            ),
            SizedBox(height: 20),
            TextField(maxLines: 8,controller: body,),
            SizedBox(height: 20),
            BasicAppButton(onPressed: () {
              DatabaseAPI.createReviews(URI, title, rating.text, body.text);
              Navigator.pop(context);
            },
            title: "Submit Review")
          ],
        ),
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