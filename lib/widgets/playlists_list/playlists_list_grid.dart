import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/config/app_scroll_behavior.dart';
import 'package:muzzbirzha_mobile/consts/consts.dart';
import 'package:muzzbirzha_mobile/models/playlist.dart';
import 'package:muzzbirzha_mobile/widgets/playlists_list/playlists_list_item.dart';

class PlayListsListGrid extends StatelessWidget {
  const PlayListsListGrid({
    super.key,
    required this.playlists,
  });

  final List<Playlist> playlists;

  @override
  Widget build(BuildContext context) {
    var colCount = MediaQuery.of(context).size.width ~/ 150;
    var itemWidth = MediaQuery.of(context).size.width ~/ colCount;

    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        child: ScrollConfiguration(
          behavior: AppScrollBehavior(),
          child: GridView(
            padding: const EdgeInsets.only(left: mainLeftMargin),
            scrollDirection: Axis.vertical,
            physics: const PageScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: colCount,
              childAspectRatio: 1.0,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
            ),
            children: playlists
                .map((p) => PlaylistsListItem(
                      playlist: p,
                      itemWidth: itemWidth,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
