import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/consts/paths.dart';
import 'package:muzzbirzha_mobile/models/album.dart';
import 'package:muzzbirzha_mobile/models/artist.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';
import 'package:muzzbirzha_mobile/providers/studio_provider.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';
import 'package:muzzbirzha_mobile/utils/string_utils.dart';
import 'package:muzzbirzha_mobile/widgets/global_using_widgets.dart';
import 'package:transparent_image/transparent_image.dart';

class StudioAlbumListItem extends StatefulWidget {
  const StudioAlbumListItem({
    super.key,
    required this.album,
  });

  final Album album;

  @override
  State<StudioAlbumListItem> createState() => _StudioAlbumListItemState();
}

class _StudioAlbumListItemState extends State<StudioAlbumListItem> {
  late final dynamic studioProvider;

  @override
  void initState() {
    studioProvider = Provider.of<StudioProvider>(context, listen: false);
    super.initState();
  }

  void confirmRemovingAlbum(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Remove album",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
          ),
          content: Text(
            "Are you shure you want to remove '${widget.album.name}'?\nYour album won't exist any more!",
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
                deleteAlbum(widget.album.id!);
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

  void deleteAlbum(int id) async {
    Artist? artist = studioProvider.artist;
    var albums = artist?.albums;

    if (albums != null) {
      Album albumToDelete = albums.firstWhere((a) => a.id == id);
      artist!.albums!.removeWhere((a) => a.id == id);
      studioProvider.artist = artist;

      if (albumToDelete.tracks != null) {
        for (var track in albumToDelete.tracks!) {
          MuzzClient().deleteTrack(track.id!);
          MuzzClient().deleteMuzFile(StringUtils().getFilePathFromUrl(
              track.streamingUrl!, albumToDelete.artist!.name!));
        }
      }
      await MuzzClient().deleteImage(
        StringUtils().getFilePathFromUrl(
          albumToDelete.imageUrl!,
          artist.name!,
        ),
      );

      await MuzzClient().deleteAlbum(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(studioAddOrEditAlbumScreenPath, arguments: widget.album),
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
                image: NetworkImage(widget.album.imageUrl!),
                fit: BoxFit.cover,
                height: MuzzTheme.albumThumb,
                width: MuzzTheme.albumThumb,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.album.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    widget.album.year!,
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
            if (widget.album.visible == false) const Icon(Icons.visibility_off),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () => confirmRemovingAlbum(context),
              icon: const Icon(Icons.remove_circle_outline_sharp),
            ),
          ],
        ),
      ),
    ));
  }
}
