import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_music/audio_meta_data.dart';

class MediaMetaDataWidget extends StatelessWidget {
  final AudioMetadata mediaMetadata;

  const MediaMetaDataWidget({super.key, required this.mediaMetadata});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, offset: Offset(2, 4), blurRadius: 4),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: mediaMetadata.artwork,
              height: 300,
              width: 300,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          mediaMetadata.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          mediaMetadata.album ?? '',
          style: const TextStyle(
            color: Colors.green,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
