import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/widgets/safe_network_image.dart';

class TracksSliderItem extends StatelessWidget {
  const TracksSliderItem({
    super.key,
    required this.track,
    required this.goToTrack,
  });
  final Track track;
  final Function() goToTrack;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: goToTrack,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              SafeNetworkImage(
                imageUrl: track.imageUrl!,
                fit: BoxFit.cover,
                height: 150,
                width: 150,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.black38,
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  child: Column(
                    children: [
                      Text(
                        track.name!,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        track.artist!.name!,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
