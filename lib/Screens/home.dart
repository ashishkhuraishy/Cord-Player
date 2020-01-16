import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/music_player.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  final MusicPlayer musicPlayer = MusicPlayer();
  List<SongInfo> songs;
  bool isPlaying = false, loadingSongs;

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  getSongs() async {
    setState(() {
      loadingSongs = true;
    });
    songs = await audioQuery.getSongs();
    setState(() => loadingSongs = false);

    songs.forEach((song) {
      print(song.displayName);

      /// prints all artist property values
    });
  }

  play(SongInfo song) {
    musicPlayer.play(MusicItem(
      albumName: song.album,
      artistName: song.artist,
      duration: Duration(milliseconds: int.parse(song.duration)),
      trackName: song.title,
      url: song.filePath,
    ));
  }

  pause() {
    musicPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cord Player"),
        ),
        body: !loadingSongs
            ? ListView.builder(
                itemCount: songs.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.amberAccent,
                    ),
                    title: Text(songs[index].title),
                    subtitle: Text(songs[index].duration),
                    trailing: !isPlaying
                        ? Icon(Icons.play_circle_filled)
                        : Icon(Icons.pause_circle_filled),
                    onTap: () {
                      print(songs[index].filePath);
                      //!isPlaying ? play(songs[index]) : pause();
                      isPlaying = !isPlaying;
                    },
                  );
                },
              )
            : Center(
                child: Text("Loading..."),
              ));
  }
}
