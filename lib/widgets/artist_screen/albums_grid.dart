import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:muzzbirzha_mobile/models/album.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';
import 'package:muzzbirzha_mobile/widgets/safe_network_image.dart';

class AlbumsGrid extends StatelessWidget {
  const AlbumsGrid({
    super.key,
    required this.albums,
  });

  final List<Album> albums;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 12) / 2; // 12 = spacing
        final itemHeight = itemWidth / 0.75; // childAspectRatio

        return Wrap(
          spacing: 12,
          runSpacing: 8,
          children: albums.map((album) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/album", arguments: album);
              },
              child: SizedBox(
                width: itemWidth,
                height: itemHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SafeNetworkImage(
                          imageUrl: album.imageUrl.toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            album.name.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: MuzzTheme.gridItemTitleStyle,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            album.year.toString(),
                            style: MuzzTheme.gridItemSubtitleStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
