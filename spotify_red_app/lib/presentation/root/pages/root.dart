import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_red_app/common/helpers/is_dark.dart';
import 'package:spotify_red_app/common/widgets/appbar/app_bar.dart';
import 'package:spotify_red_app/common/widgets/button/basic_app_button.dart';
import 'package:spotify_red_app/common/widgets/play_button/song_controls.dart';
import 'package:spotify_red_app/core/configs/assets/app_vectors.dart';
import 'package:spotify_red_app/core/configs/theme/app_colors.dart';
import 'package:spotify_red_app/core/configs/storage_service.dart';
import 'package:spotify_red_app/core/configs/database_auth.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});
  
  @override
  State<StatefulWidget> createState() => Root();
}

class Root extends State<RootPage> {
  int currentPageIndex = 0;
  String? _spotifyToken;
  DatabaseUserProfile? _databaseProfile;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    String? token = await TokenStorageService().getSpotifyToken();
    setState(() {
      _spotifyToken = token;
    });

    connectToSpotifyRemote();

    DatabaseUserProfile? profile = await DatabaseRepository().fetchUserProfile();
    setState(() {
      _databaseProfile = profile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _navBar(),
      appBar: BasicAppbar(),
      body: _pages[currentPageIndex],
    );
  }

  List<Widget> get _pages => [
        _feedPage(),
        _libraryPage(),
        _profilePage(),
      ];

  Widget _feedPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20), // Spacing

          if (_databaseProfile != null)
            Column(
              children: [
                Text("Database Username: ${_databaseProfile!.username}"),
                Text("Friends: ${_databaseProfile!.friends.length}"),
                Text("Privacy Level: ${_databaseProfile!.privacy}"),
              ],
            )
          else
            const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _libraryPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [SongControls()],
          ),
        ],
      ),
    );
  }

  Widget _profilePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_spotifyToken != null)
            BasicAppButton(
              onPressed: TokenStorageService().clearAll,
              title: 'Delete Stored Data'
            )
          else
            const CircularProgressIndicator()
        ],
      ),
    );
  }

  Widget _navBar() {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      indicatorColor: AppColors.primary,
      selectedIndex: currentPageIndex,
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home, color: context.isDarkMode ? Colors.white : Colors.white),
          icon: const Icon(Icons.home),
          label: 'Feed',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.library_music, color: context.isDarkMode ? Colors.white : Colors.white),
          icon: const Icon(Icons.library_music),
          label: 'Library',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.portrait_rounded, color: context.isDarkMode ? Colors.white : Colors.white),
          icon: const Icon(Icons.portrait_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}

Future<void> connectToSpotifyRemote() async {
  try {
    var result = await SpotifySdk.connectToSpotifyRemote(
        clientId: "96ff1332017242f0b78cdbb128c3f07d",
        redirectUrl: "myapp://callback");
  } on PlatformException catch (e) {
    print(e);
  } on MissingPluginException {
    print('MissingPluginException');
  }
}
