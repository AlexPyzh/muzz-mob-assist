import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/artist.dart';
import 'package:muzzbirzha_mobile/widgets/safe_network_image.dart';

class ArtistsSliderItem extends StatelessWidget {
  const ArtistsSliderItem({
    super.key,
    required this.artist,
    required this.path,
  });
  final Artist artist;
  final String path;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, path, arguments: artist.id);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipOval(
            child: SizedBox(
              width: 140,
              height: 140,
              child: SafeNetworkImage(
                imageUrl: artist.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            artist.name!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
