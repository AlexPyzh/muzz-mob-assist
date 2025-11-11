import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/consts/paths.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';
import 'package:muzzbirzha_mobile/providers/studio_provider.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';
import 'package:muzzbirzha_mobile/utils/string_utils.dart';
import 'package:muzzbirzha_mobile/widgets/global_using_widgets.dart';
import 'package:transparent_image/transparent_image.dart';

class StudioSingleListItem extends StatefulWidget {
  const StudioSingleListItem({
    super.key,
    required this.track,
  });

  final Track track;

  @override
  State<StudioSingleListItem> createState() => _StudioSingleListItemState();
}

class _StudioSingleListItemState extends State<StudioSingleListItem> {
  late final dynamic studioProvider;

  @override
  void initState() {
    studioProvider = Provider.of<StudioProvider>(context, listen: false);
    super.initState();
  }

  void confirmRemovingSingle(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Remove single",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
          ),
          content: Text(
            "Are you shure you want to remove '${widget.track.name}'?\nYour single won't exist any more!",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteSingle(widget.track.id!);
              },
              child: const Text("Yes, I's my decision"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Gosh no!"),
            ),
          ],
        );
      },
    );
  }

  void deleteSingle(int trackId) async {
    Artist? artist = studioProvider.artist;
    var tracks = artist?.tracks;

    if (tracks != null) {
      Track trackToDelete = tracks.firstWhere((a) => a.id == trackId);
      artist!.tracks!.removeWhere((t) => t.id == trackId);
      studioProvider.artist = artist;

      MuzzClient().deleteTrack(trackId);
      MuzzClient().deleteMuzFile(StringUtils().getFilePathFromUrl(
          trackToDelete.streamingUrl!, trackToDelete.artist!.name!));

      if (trackToDelete.imageUrl != null) {
        await MuzzClient().deleteImage(
          StringUtils().getFilePathFromUrl(
            trackToDelete.imageUrl!,
            artist.name!,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(studioAddOrEditSingleScreenPath, arguments: widget.track),
      child: Card(
        color: MuzzTheme.tileAsh,
        margin: const EdgeInsets.only(bottom: 10),
        clipBehavior: Clip.none,
        child: Padding(padding: const EdgeInsets.all(MuzzTheme.tilePad), child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(widget.track.imageUrl!),
                fit: BoxFit.cover,
                height: MuzzTheme.singleThumb,
                width: MuzzTheme.singleThumb,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.track.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (widget.track.year != null)
                    Text(
                      widget.track.year!.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                ],
              ),
            ),
            const Spacer(),
            if (widget.track.visible == false) const Icon(Icons.visibility_off),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () => confirmRemovingSingle(context),
              icon: const Icon(Icons.remove_circle_outline_sharp),
            ),
          ],
        ),
      ),
    ));
  }
}
