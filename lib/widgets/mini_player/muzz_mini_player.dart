import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:muzzbirzha_mobile/providers/track_list_provider.dart';
import 'package:muzzbirzha_mobile/widgets/player/muzz_player.dart';
import 'package:muzzbirzha_mobile/widgets/safe_network_image.dart';
import 'package:provider/provider.dart';

class MuzzMiniPlayer extends StatefulWidget {
  const MuzzMiniPlayer({super.key});

  @override
  State<MuzzMiniPlayer> createState() => _MuzzMiniPlayerState();
}

class _MuzzMiniPlayerState extends State<MuzzMiniPlayer> {
  static const double _playerMinHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<TrackListProvider>(builder: (context, value, child) {
      return Miniplayer(
        controller: value.miniPlayerController,
        minHeight: _playerMinHeight,
        maxHeight: MediaQuery.of(context).size.height,
        builder: (height, percentage) {
          // if (value.currentTrackIndex == null) {
          //   return const SizedBox.shrink();
          // }
          if (height <= _playerMinHeight + 50) {
            return Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Center(
                  child: Column(
                children: [
                  Row(
                    children: [
                      SafeNetworkImage(
                        imageUrl: value.currentTrack.imageUrl!,
                        height: _playerMinHeight - 4.0,
                        width: _playerMinHeight - 4.0,
                        fit: BoxFit.cover,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  value.currentTrack.name!,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  value.currentTrack.artist!.name!,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: value.pauseOrResume,
                        icon: value.isPlaying
                            ? const Icon(Icons.pause)
                            : const Icon(Icons.play_arrow),
                      ),
                      IconButton(
                        onPressed: () {
                          value.currentTrackIndex = null;
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  LinearProgressIndicator(
                    value: value.currentDurartion!.inSeconds.toDouble() /
                        value.totalDurartion!.inSeconds.toDouble(),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white70),
                  )
                ],
              )),
            );
          }
          return const MuzzPlayer();
        },
      );
    });
  }
}
