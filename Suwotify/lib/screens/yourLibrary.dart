// ignore_for_file: camel_case_types
import 'dart:convert';
import 'package:Suwotify/screens/playlistScreen.dart';
import 'package:Suwotify/services/baseAPI/user.dart';
import 'package:http/http.dart' as http;
import 'package:Suwotify/components/StorageKey.dart';
import 'package:Suwotify/screens/library/libraryMusic.dart';
import 'package:Suwotify/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Suwotify/services/baseAPI/playlist.dart';

class YourLibrary extends StatefulWidget {
  const YourLibrary({Key? key}) : super(key: key);

  @override
  State<YourLibrary> createState() => _YourLibraryState();
}

class _YourLibraryState extends State<YourLibrary> {
  late String token = '';
  bool loadingStatus = false;
  int idUser = 0;
  List<dynamic> dataUser = [];
  // ignore: non_constant_identifier_names
  final Tab = [
    const LibraryMusic(),
    const LibraryMusic(),
    const LibraryMusic()
  ];
  Color tabColor(int index) {
    return index == currentTabIndex
        ? const Color(0xB2D9D9D9)
        : Colors.transparent;
  }

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    getToken();
    getUserData();
  }

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString(StorageKey.TOKEN) as String;
    });
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loadingStatus = true;
    });
    try {
      http.Response? response =
          await getUser(prefs.getString(StorageKey.TOKEN) ?? "");
      final decodedData = json.decode(response!.body);

      setState(() {
        dataUser = Map.from(decodedData).values.toList();
        loadingStatus = false;
      });
      idUser = dataUser[0];
      print("id : $idUser");
    } catch (error) {
      print(error.toString());
    }
  }

  createNavBarTop() {
    return AppBar(
      backgroundColor: const Color.fromRGBO(56, 27, 136, 1),
      elevation: 0.0,
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  currentTabIndex = 0;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                width: 72,
                height: 25,
                decoration: ShapeDecoration(
                  color: tabColor(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 5,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Music',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Harmattan',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  currentTabIndex = 1;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                width: 70,
                height: 25,
                decoration: ShapeDecoration(
                  color: tabColor(1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 5,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Podcast',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Harmattan',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  currentTabIndex = 2;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                width: 72,
                height: 25,
                decoration: ShapeDecoration(
                  color: tabColor(2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 5,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Radio',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Harmattan',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  createAppBar() {
    return AppBar(
      backgroundColor: const Color.fromRGBO(56, 27, 136, 1),
      elevation: 0.0,
      title: Container(
        margin: const EdgeInsets.only(top: 30, left: 10, right: 10),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Suwotify',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: 'Gotham Black',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            Icon(Icons.account_circle),
          ],
        ),
      ),
    );
  }

  _showAddNewModal(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add New Playlist',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Access the input values
                    String name = nameController.text;
                    String description = descriptionController.text;
                    createPlaylist(idUser, token, name, description);
                    Navigator.pop(context); // Close the modal
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(),
      body: token == ''
          ? Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromRGBO(56, 27, 136, 1), Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.6],
                ),
              ),
              child: Center(
                child: Container(
                  width: 200,
                  height: 35,
                  decoration: ShapeDecoration(
                    color: const Color.fromRGBO(56, 27, 136, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Login Dulu Dong',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Color.fromRGBO(56, 27, 136, 1), Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.6],
                )),
                child: Column(
                  children: [
                    createNavBarTop(),
                    Container(
                      width: 150,
                      height: 35,
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          _showAddNewModal(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text(
                          'Add New',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const playlist()
                  ],
                ),
              ),
            ),
    );
  }
}

class playlist extends StatefulWidget {
  const playlist({super.key});

  @override
  State<playlist> createState() => _playlistState();
}

class playlistData {
  final int id;
  final String name;
  final String description;

  playlistData({
    required this.id,
    required this.name,
    required this.description,
  });
}

class _playlistState extends State<playlist> {
  List<dynamic> dataPlaylist = [];
  List<playlistData> playlist = [];
  int idUser = 0;
  List<dynamic> dataUser = [];
  int currentIndex = 0;

  bool loadingStatus = false;

  @override
  void initState() {
    super.initState();
    //apo ni
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getAllPlaylist();
    });
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loadingStatus = true;
    });
    try {
      http.Response? response =
          await getUser(prefs.getString(StorageKey.TOKEN) ?? "");
      final decodedData = json.decode(response!.body);

      setState(() {
        dataUser = Map.from(decodedData).values.toList();
        loadingStatus = false;
      });
      idUser = (dataUser[0]);
      print("id : $idUser");
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> getAllPlaylist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loadingStatus = true;
    });
    try {
      http.Response? response = await getPlaylist(
          'image', 'users', prefs.getString(StorageKey.TOKEN) ?? "");

      final decodedData = json.decode(response!.body);
      setState(() {
        dataPlaylist = Map.from(decodedData).values.toList();
        loadingStatus = false;
      });

      if (dataPlaylist != null) {
        await getUserData();
        for (int i = 0; i < dataPlaylist[0].length; i++) {
          print(dataPlaylist[0][i]);
          print(dataPlaylist[0].length);
          int id = dataPlaylist[0][i]['id'];
          String name = (dataPlaylist[0][i]['attributes']['name']);
          String deskripsi = (dataPlaylist[0][i]['attributes']['deskripsi']);
          int user = (dataPlaylist[0][i]['attributes']['users']['data']['id']);
          if (user == idUser) {
            print(1);
            playlist.add(
              playlistData(
                id: id,
                description: deskripsi,
                name: name,
              ),
            );
          }
          print("done1");
        }
      }
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ListView.builder(
        itemCount: playlist.length,
        itemBuilder: (BuildContext context, int index) {
          final currentPlaylist = playlist[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaylistScreen(id: currentPlaylist.id),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: const Color(0x7FD9D9D9),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Title:',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          currentPlaylist.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Deskripsi:',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          currentPlaylist.description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
