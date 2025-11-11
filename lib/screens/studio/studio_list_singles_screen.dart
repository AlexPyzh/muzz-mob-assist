import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';
import 'package:muzzbirzha_mobile/consts/consts.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/providers/studio_provider.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_add_single_button.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_single_list_item.dart';
import 'package:provider/provider.dart';

class StudioListSinglesScreen extends StatelessWidget {
  const StudioListSinglesScreen({
    super.key,
    this.embedded = false,
  });

  final bool embedded;

  Widget _embedded(StudioProvider value) {
    final singles = value.artist!.tracks!.where((t) => t.isSingle == true).toList();
    return _StudioSinglesBody(value: value, singles: singles);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudioProvider>(
      builder: (context, value, child) {
        if (value.artist == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (embedded) {
            return _embedded(value);
          }
          return embedded ? _embedded(value) : Scaffold(appBar: AppBar(title: Text("${value.artist!.name} singles")), body: _embedded(value));
}
      },
    );
  }
}

class _StudioSinglesBody extends StatelessWidget {
  final StudioProvider value;
  final List<Track> singles;
  const _StudioSinglesBody({required this.value, required this.singles});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: mainLeftMargin, right: 16),
            child: ListView.separated(
              itemCount: singles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final Track track = singles[index];
                return StudioSingleListItem(track: track);
              },
            ),
          ),
        ),
        SafeArea(
          minimum: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: StudioAddSingleButton(artist: value.artist!),
          ),
        ),
      ],
    );
  }
}