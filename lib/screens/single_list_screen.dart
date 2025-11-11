import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/widgets/artist_screen/singles_grid.dart';

class SingleListScreen extends StatelessWidget {
  const SingleListScreen({
    super.key,
    required this.appBarTitle,
    required this.singles,
  });

  final String appBarTitle;
  final List<Track> singles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: SinglesGrid(singles: singles),
        ),
      ),
    );
  }
}
