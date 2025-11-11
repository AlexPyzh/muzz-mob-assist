import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:muzzbirzha_mobile/components/neu_box.dart';
import 'package:muzzbirzha_mobile/providers/track_list_provider.dart';
import 'package:muzzbirzha_mobile/widgets/dialogs/invest_dialog.dart';
import 'package:muzzbirzha_mobile/widgets/player/like_button.dart';
import 'package:muzzbirzha_mobile/widgets/safe_network_image.dart';
import 'package:provider/provider.dart';

class MuzzPlayer extends StatelessWidget {
  const MuzzPlayer({super.key});

  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrackListProvider>(builder: (connext, value, child) {
      final trackList = value.trackList;
      final currentTrack = trackList[value.currentTrackIndex ?? 0];
      final canInvest = currentTrack.finInfo != null;

      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => value.miniPlayerController!
                            .animateToHeight(state: PanelState.MIN),
                        icon: const Icon(Icons.arrow_downward_sharp),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  NeuBox(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SafeNetworkImage(
                            imageUrl: currentTrack.imageUrl!,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentTrack.name.toString(),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      value.miniPlayerController!
                                          .animateToHeight(
                                              state: PanelState.MIN);

                                      Navigator.pushNamed(
                                          value.buildContext, "/artist",
                                          arguments: currentTrack.artistId!);
                                    },
                                    child: Text(
                                      currentTrack.artist!.name.toString(),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const LikeButton(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatTime(value.currentDurartion!),
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            GestureDetector(
                              child: const Icon(
                                Icons.playlist_add,
                                color: Colors.white70,
                              ),
                            ),
                            GestureDetector(
                              child: Icon(
                                Icons.monetization_on_outlined,
                                color:
                                    canInvest ? Colors.white70 : Colors.white30,
                              ),
                              onTap: () => canInvest
                                  ? showInvestDialog(
                                      context, value.currentTrack)
                                  : null,
                            ),
                            Text(
                              formatTime(value.totalDurartion!),
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 0),
                        ),
                        child: Slider(
                          min: 0,
                          max: value.totalDurartion!.inSeconds.toDouble(),
                          value: value.currentDurartion!.inSeconds.toDouble(),
                          activeColor: Colors.white70,
                          onChanged: (value) {},
                          onChangeEnd: (double double) {
                            value.seek(Duration(seconds: double.toInt()));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playPreviosTrack,
                          child: const NeuBox(
                            child: Icon(Icons.skip_previous),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.pauseOrResume,
                          child: NeuBox(
                            child: Icon(value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playNextTrack,
                          child: const NeuBox(
                            child: Icon(Icons.skip_next),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
