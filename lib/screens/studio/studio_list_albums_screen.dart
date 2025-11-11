import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';
import 'package:muzzbirzha_mobile/consts/consts.dart';
import 'package:muzzbirzha_mobile/models/album.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/providers/studio_provider.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_add_album_button.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_album_list_item.dart';
import 'package:provider/provider.dart';

class StudioListAlbumsScreen extends StatefulWidget {
  const StudioListAlbumsScreen({
    super.key,
    this.embedded = false,
  });

  final bool embedded;

  @override
  State<StudioListAlbumsScreen> createState() => _StudioListAlbumsScreenState();
}

class _StudioListAlbumsScreenState extends State<StudioListAlbumsScreen> {
  Widget _embedded(StudioProvider value) {
    final albums = value.artist!.albums ?? [];
    return _StudioAlbumsBody(value: value, albums: albums);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudioProvider>(
      builder: (context, value, child) {
        if (value.artist == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (widget.embedded) {
            return _embedded(value);
          }
          return widget.embedded ? _embedded(value) : Scaffold(appBar: AppBar(title: Text("${value.artist!.name} albums")), body: _embedded(value));
}
      },
    );
  }
}

class _StudioAlbumsBody extends StatelessWidget {
  final StudioProvider value;
  final List<Album> albums;
  const _StudioAlbumsBody({required this.value, required this.albums});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: mainLeftMargin, right: 16),
            child: ListView.separated(
              itemCount: albums.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final Album album = albums[index];
                return StudioAlbumListItem(album: album);
              },
            ),
          ),
        ),
        SafeArea(
          minimum: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: StudioAddAlbumButton(artist: value.artist!),
          ),
        ),
      ],
    );
  }
}