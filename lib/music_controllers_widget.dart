import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicControllersWidget extends StatelessWidget {
  final AudioPlayer audioPlayer;

  const MusicControllersWidget({super.key, required this.audioPlayer});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: audioPlayer.seekToPrevious,
          icon: const Icon(Icons.skip_previous_rounded),
          iconSize: 80,
          color: Colors.white,
        ),
        SizedBox(
          width: 80,
          child: Center(
            child: StreamBuilder<PlayerState>(
              stream: audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                debugPrint(processingState.toString());
                final playing = playerState?.playing;
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return const CircularProgressIndicator(
                    color: Colors.white,
                  );
                } else {
                  if (!(playing ?? false)) {
                    return IconButton(
                      onPressed: audioPlayer.play,
                      icon: const Icon(Icons.play_arrow_rounded),
                      iconSize: 80,
                      color: Colors.white,
                    );
                  } else if (processingState != ProcessingState.completed) {
                    return IconButton(
                      onPressed: audioPlayer.pause,
                      icon: const Icon(Icons.pause_rounded),
                      iconSize: 80,
                      color: Colors.white,
                    );
                  }
                }
                return const Icon(
                  Icons.play_arrow_rounded,
                  size: 80,
                  color: Colors.white,
                );
              },
            ),
          ),
        ),
        IconButton(
          onPressed: audioPlayer.seekToNext,
          icon: const Icon(Icons.skip_next_rounded),
          iconSize: 80,
          color: Colors.white,
        ),
      ],
    );
  }
}
