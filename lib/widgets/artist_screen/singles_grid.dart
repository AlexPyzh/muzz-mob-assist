import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';
import 'package:muzzbirzha_mobile/widgets/safe_network_image.dart';

class SinglesGrid extends StatelessWidget {
  const SinglesGrid({
    super.key,
    required this.singles,
  });

  final List<Track> singles;

  @override
  Widget build(BuildContext context) {
    // Для синглов картинка должна быть в 1.5 раза меньше
    // Если у альбомов aspect ratio 1.0 для картинки, то у синглов будет меньше
    // Увеличим crossAxisCount до 3 для более компактного отображения
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - 16) / 3; // 16 = 2 * spacing(8)
        final itemHeight = itemWidth / 0.70; // childAspectRatio

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: singles.map((single) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/single", arguments: single);
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
                        borderRadius: BorderRadius.circular(8),
                        child: SafeNetworkImage(
                          imageUrl: single.imageUrl ?? '',
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
                            single.name ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: MuzzTheme.gridItemTitleStyle,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            single.year?.toString() ?? '',
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
