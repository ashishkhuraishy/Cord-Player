import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  AudioPlayer audioPlayer;
  List<SongInfo> songs;
  bool isPlaying = false, loadingSongs;
  AudioPlayerState playerState;
  String kUrl;


  @override
  void initState() {
    super.initState();
    getSongs();
    audioPlayer = new AudioPlayer();
  }

  setPlayerState() {
    setState(() {
      playerState = audioPlayer.state;
    });
  }

  getSongs() async {
    setState(() {
      loadingSongs = true;
    });
    songs = await audioQuery.getSongs();

    setState(() => loadingSongs = false);

    songs.forEach((song) {
      print(song.displayName);
    });
  }

  toggle() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  changeSong(String path) async {
    await stop();
    setState(() {
      kUrl = path;
    });
  }

  play() async {
    await audioPlayer.play(kUrl, isLocal: true);
    setPlayerState();
    toggle();
  }

  pause() async {
    await audioPlayer.pause();
    setPlayerState();
    toggle();
  }

  stop() async {
    await audioPlayer.stop();
    setPlayerState();
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
                    child: songs[index].albumArtwork != null ? Image.file(File(songs[index].albumArtwork)) : Image.asset("assets/images/placeholder.png"),
                  ),
                  title: Text(songs[index].title),
                  subtitle: Text(songs[index].duration),
                  trailing: isPlaying && kUrl == songs[index].filePath
                      ? Icon(Icons.pause_circle_filled)
                      : Icon(Icons.play_circle_filled),
                  onTap: () async {
                    String path = songs[index].filePath;
                    print(playerState);

                    if (isPlaying && kUrl != null) {
                      if (kUrl == path) {
                        await pause();
                      } else {
                        toggle();
                        await changeSong(path);
                        await play();
                      }
                    } else {
                      if (kUrl == null || kUrl != path) {
                        await changeSong(path);
                      }
                      await play();
                    }
                    print(playerState);
                  },
                  onLongPress: () => stop(),
                );
              },
            )
          : Center(
              child: Text("Loading..."),
            ),
    );
  }
}
