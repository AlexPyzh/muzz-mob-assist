import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';
import 'package:muzzbirzha_mobile/models/artist.dart';
import 'package:provider/provider.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';
import 'package:muzzbirzha_mobile/screens/studio/studio_list_albums_screen.dart';
import 'package:muzzbirzha_mobile/screens/studio/studio_list_singles_screen.dart';
import 'package:muzzbirzha_mobile/screens/studio/studio_artist_about_tab.dart';
import 'package:muzzbirzha_mobile/providers/studio_provider.dart';

class StudioArtistScreen extends StatefulWidget {
  const StudioArtistScreen({required this.artistId, super.key});
  final int artistId;

  @override
  State<StudioArtistScreen> createState() => _StudioArtistScreenState();
}

class _StudioArtistScreenState extends State<StudioArtistScreen> {
  Future<Artist?>? _futureArtist;

  @override
  void initState() {
    super.initState();
    loadArtist();
  }

  Future loadArtist() async {
    final studioProvider = context.read<StudioProvider>();
    _futureArtist =
        MuzzClient().getArtistById(widget.artistId, showNotPublished: true);
    studioProvider.artist = await _futureArtist;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Artist?>(
      future: _futureArtist,
      builder: (context, snapshot) {
        final artistName = context.read<StudioProvider>().artist?.name ?? "";
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Improve '$artistName'"),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: Column(
                  children: [
                    Divider(height: 1, color: MuzzTheme.dividerAsh),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          tabBarTheme: Theme.of(context)
                              .tabBarTheme
                              .copyWith(dividerColor: Colors.transparent),
                        ),
                        child: TabBar(
                          isScrollable: false,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 6),
                          indicatorPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          indicator: ShapeDecoration(
                            shape: StadiumBorder(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: MuzzTheme.pillOutlineWidth,
                              ),
                            ),
                          ),
                          tabs: const [
                            _StudioPillTab(label: "Albums"),
                            _StudioPillTab(label: "Singles"),
                            _StudioPillTab(label: "Videos"),
                            _StudioPillTab(label: "About"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: const TabBarView(
              children: [
                StudioListAlbumsScreen(embedded: true),
                StudioListSinglesScreen(embedded: true),
                Center(child: Text("Videos — coming soon")),
                StudioArtistAboutTab(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StudioPillTab extends StatelessWidget {
  final String label;
  const _StudioPillTab({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context)
        .textTheme
        .labelLarge
        ?.copyWith(fontSize: MuzzTheme.pillFontSize);
    return Tab(
      child: SizedBox(
        height: MuzzTheme.pillHeight,
        width: MuzzTheme.pillMinWidth,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: MuzzTheme.pillOutlineInactive),
            borderRadius: BorderRadius.circular(MuzzTheme.pillRadius),
          ),
          child: Text(label, style: style, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
