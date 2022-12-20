import 'package:just_audio_background/just_audio_background.dart';

class AudioMetadata extends MediaItem{
  final String artwork;
  AudioMetadata({
    required this.artwork,
    required String id,
    required String title,
    required String album,
    required Uri artUri,
  }) : super(id: id, title: title, artUri: artUri, album: album);
}