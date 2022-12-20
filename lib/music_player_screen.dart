import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music/audio_meta_data.dart';
import 'package:flutter_music/media_meta_data_widget.dart';
import 'package:flutter_music/music_controllers_widget.dart';
import 'package:flutter_music/position_data.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MusicPlayerScreenState();
  }
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late AudioPlayer _audioPlayer;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferPosition, duration) =>
            PositionData(position, bufferPosition, duration ?? Duration.zero),
      );

  final _playList = ConcatenatingAudioSource(children: [
    // LockCachingAudioSource(
    //   Uri.parse('https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3'),
    //   tag: AudioMetadata(
    //     id: "1",
    //     album: "Public Domain哈哈1",
    //     title: "Nature Sounds滴滴1",
    //     artUri: Uri.parse(
    //         'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.bugela.com%2Fuploads%2F2021%2F04%2F19%2F9c91167166fbb24fa92e2c1b42994bc6.jpg&refer=http%3A%2F%2Fimg.bugela.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673240325&t=78b9223d04d740eda317572855505596'),
    //     artwork:
    //         'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.bugela.com%2Fuploads%2F2021%2F04%2F19%2F9c91167166fbb24fa92e2c1b42994bc6.jpg&refer=http%3A%2F%2Fimg.bugela.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673240325&t=78b9223d04d740eda317572855505596',
    //   ),
    // ),
    // LockCachingAudioSource(
    //   Uri.parse('https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3'),
    //   tag: AudioMetadata(
    //     id: "2",
    //     album: "Public Domain哈哈2",
    //     title: "Nature Sounds滴滴2",
    //     artUri: Uri.parse(
    //         'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fup.enterdesk.com%2Fedpic_source%2F3d%2F42%2F3e%2F3d423e3cb05d7edc35c38e3173af2a0d.jpg&refer=http%3A%2F%2Fup.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673240325&t=f9156650c69c2e0b4196b6798fb8cdb3'),
    //     artwork:
    //         'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fup.enterdesk.com%2Fedpic_source%2F3d%2F42%2F3e%2F3d423e3cb05d7edc35c38e3173af2a0d.jpg&refer=http%3A%2F%2Fup.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673240325&t=f9156650c69c2e0b4196b6798fb8cdb3',
    //   ),
    // ),
    AudioSource.uri(
      Uri.parse("asset:///assets/audio/nature.aac"),
      tag: AudioMetadata(
        id: "3",
        album: "Public Domain",
        title: "Nature Sounds",
        artUri: Uri.parse(
            'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fm.imeitou.com%2Fuploads%2Fallimg%2F210717%2F3-210GG64111.jpg&refer=http%3A%2F%2Fm.imeitou.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673182853&t=2965c399c34c4620354cff2e2a2d1886'),
        artwork:
            'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fm.imeitou.com%2Fuploads%2Fallimg%2F210717%2F3-210GG64111.jpg&refer=http%3A%2F%2Fm.imeitou.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673182853&t=2965c399c34c4620354cff2e2a2d1886',
      ),
    ),
    ClippingAudioSource(
      start: const Duration(seconds: 60),
      end: const Duration(seconds: 90),
      child: AudioSource.uri(Uri.parse(
          "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")),
      tag: AudioMetadata(
        id: "4",
        album: "Science Friday",
        title: "A Salute To Head-Scratching Science (30 seconds)",
        artUri: Uri.parse(
            "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.bugela.com%2Fuploads%2F2021%2F04%2F26%2FTX9490_04.jpg&refer=http%3A%2F%2Fimg.bugela.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673182853&t=066a0472b40a6c6a7042f48f1142bca8"),
        artwork:
            'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.bugela.com%2Fuploads%2F2021%2F04%2F26%2FTX9490_04.jpg&refer=http%3A%2F%2Fimg.bugela.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673182853&t=066a0472b40a6c6a7042f48f1142bca8',
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),
      tag: AudioMetadata(
        id: '5',
        album: "Science Friday",
        title: "A Salute To Head-Scratching Science",
        artUri: Uri.parse(
            "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fup.enterdesk.com%2Fedpic%2F75%2Fdc%2F50%2F75dc50577d3d3d2bd5fd8db728e7bf77.jpg&refer=http%3A%2F%2Fup.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673182962&t=7aafa52966795a5f2a9bb2e42b51e627"),
        artwork:
            'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fup.enterdesk.com%2Fedpic%2F75%2Fdc%2F50%2F75dc50577d3d3d2bd5fd8db728e7bf77.jpg&refer=http%3A%2F%2Fup.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673182962&t=7aafa52966795a5f2a9bb2e42b51e627',
      ),
    ),
    AudioSource.uri(
      Uri.parse("https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3"),
      tag: AudioMetadata(
        id: '6',
        album: "Science Friday",
        title: "From Cat Rheology To Operatic Incompetence",
        artUri: Uri.parse(
            "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
        artwork:
            'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg',
      ),
    ),
  ]);

  @override
  void initState() {
    super.initState();
    // _audioPlayer = AudioPlayer()..setAsset('assets/audio/nature.aac');
    // _audioPlayer = AudioPlayer()..setUrl('https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac');
    _audioPlayer = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(_playList);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: Stack(
        children: [
          StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color(0xFF144771), Color(0xff071a2c)],
                      ),
                    ),
                  );
                }
                final metadata = state?.currentSource?.tag as AudioMetadata;
                final artwork = metadata.artwork;
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  constraints: const BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(artwork),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                    child: Container(
                      color: Colors.black12,
                    ),
                  ),
                );
              }),
          Container(
            padding: const EdgeInsets.all(20),
            height: double.infinity,
            width: double.infinity,
            // decoration: const BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topRight,
            //     end: Alignment.bottomLeft,
            //     colors: [Color(0xFF144771), Color(0xff071a2c)],
            //   ),
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StreamBuilder<SequenceState?>(
                  stream: _audioPlayer.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    if (state?.sequence.isEmpty ?? true) {
                      return const SizedBox();
                    }
                    final metadata = state?.currentSource?.tag as AudioMetadata;
                    return MediaMetaDataWidget(mediaMetadata: metadata);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return ProgressBar(
                      barHeight: 8,
                      baseBarColor: Colors.grey[600],
                      bufferedBarColor: Colors.grey,
                      progressBarColor: Colors.red,
                      thumbColor: Colors.red,
                      timeLabelTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      progress: positionData?.position ?? Duration.zero,
                      total: positionData?.duration ?? Duration.zero,
                      buffered: positionData?.bufferPosition ?? Duration.zero,
                      onSeek: _audioPlayer.seek,
                    );
                  },
                ),
                MusicControllersWidget(audioPlayer: _audioPlayer),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
