import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_red_app/common/helpers/is_dark.dart';
import 'package:spotify_red_app/common/widgets/appbar/app_bar.dart';
import 'package:spotify_red_app/common/widgets/button/basic_app_button.dart';
import 'package:spotify_red_app/common/widgets/play_button/song_controls.dart';
import 'package:spotify_red_app/core/configs/database_api.dart';
import 'package:spotify_red_app/core/configs/spotify_api.dart';
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
  int friendPageIndex = 0;
  String? _spotifyToken;
  List<Widget> _friendRequests = [Text('data')];
  List<Widget> _playlists = [Text('data')];
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

    refreshFriendRequests();
    refreshPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _navBar(),
      body: Scaffold(
        bottomNavigationBar: _songBar(),
        body: _pages[currentPageIndex],
      ) 
    );
  }

  List<Widget> get _pages => [
    _feedPage(),
    _libraryPage(),
    _friendPage(),
    _profilePage(),
  ];
  
  List<Widget> get _friendPages => [
    _friends(),
    _addFriend(),
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
                Text("Friends: ${_databaseProfile!.friends}"),
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BasicAppButton(
              onPressed: () async {refreshPlaylists();},
              title: 'Refresh'
            ),
            Column(
              children: _playlists,
            ),
          ],
        ),
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

  Widget _friendPage() {
    NavigationDestinationLabelBehavior.onlyShowSelected;
    return Column(
      children: [
        NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              friendPageIndex = index;
            });
          },
          indicatorColor: AppColors.primary,
          selectedIndex: friendPageIndex,
          destinations: <Widget>[
            NavigationDestination(
              icon: const Text('Friends'),
              label: '1',
            ),
            NavigationDestination(
              icon: Text('Add Friend'),
              label: '2',
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: 
            SingleChildScrollView(
              child: Column(
                children: [
                  if (_databaseProfile != null)
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: _friendPages[friendPageIndex],
                      )
                  else
                    const CircularProgressIndicator()
                ],
              ),
            )
        ),
      ],
    );
  }

  Widget _friends() {
    return Column(
      children: [
        for (var item in _databaseProfile!.friends)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.lightBlue.shade900),
            ),
          ),
          child: Text(item)
        )
      ],
    );
  }

  Widget _addFriend() {
    var friendText = TextEditingController();
    var _requests = Text('No Friend Requests');
    return Column(
      mainAxisSize: MainAxisSize.max, 
      children: [
        Row(
          mainAxisSize: MainAxisSize.max, 
          children: [
            Expanded(
              child: TextField(
                controller: friendText,
                decoration: InputDecoration(labelText: 'Username'),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              width: 100,
              child: BasicAppButton(
                onPressed: () async {await DatabaseAPI.createFriendRequest(friendText.text);},
                title: 'Add'
              ),
            ),
          ]
        ),
        SizedBox(height: 10),
        BasicAppButton(          
          height: 40,
          onPressed: () async {
            refreshFriendRequests();
          },
          title: 'Refresh'
        ),
        SingleChildScrollView(
          child: Column(
            children: _friendRequests,
          ),
        )
      ],
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
          selectedIcon: Icon(Icons.forum_outlined, color: context.isDarkMode ? Colors.white : Colors.white),
          icon: const Icon(Icons.forum_outlined),
          label: 'Friends',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.portrait_rounded, color: context.isDarkMode ? Colors.white : Colors.white),
          icon: const Icon(Icons.portrait_rounded),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _songBar() {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          SongControls()
        ],
      ),
    );
  }

  void refreshFriendRequests() async {
    List<Widget> requests = [];
    dynamic friendRequestsJSON = (await DatabaseAPI.getFriendRequests());

    for (var request in friendRequestsJSON) {
      requests.add(
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.grey),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(request['from_uid']),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              await DatabaseAPI.respondFriendRequest(request['to_uid'], request['from_uid'], 'yes');
                              refreshFriendRequests();
                            },
                            child: Text(
                              'Accept',
                              style: TextStyle(
                                color: Colors.green.shade600
                              ),
                            )
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              await DatabaseAPI.respondFriendRequest(request['to_uid'], request['from_uid'], 'no');
                              refreshFriendRequests();
                            },
                            child: Text(
                              'Reject',
                              style: TextStyle(
                                color: Colors.red.shade600
                              ),
                            )
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        )
      );
    }

    setState(() {
      _friendRequests = requests;
    });
  }

  void refreshPlaylists() async {
    List<Widget> playlists = [];
    dynamic playlistJSON = (await SpotifyAPI.getPlaylists())?['items'];

    for (var playlist in playlistJSON) {
      playlists.add(
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  SpotifyAPI.playMusic(playlist['id']);
                  SongControls.updatePlayback();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: Colors.grey),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(playlist['id']),
                      Text(playlist['name'])
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      );
    }

    setState(() {
      _playlists = playlists;
    });
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
