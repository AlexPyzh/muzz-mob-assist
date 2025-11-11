import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/consts/paths.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';
import 'package:muzzbirzha_mobile/providers/auth_provider.dart';
import 'package:muzzbirzha_mobile/widgets/global_using_widgets.dart';
import 'package:muzzbirzha_mobile/widgets/home_screen/artists_slider/artists_slider_item.dart';
import 'package:provider/provider.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_add_artist_button.dart';

class StudioScreen extends StatefulWidget {
  const StudioScreen({super.key});

  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen> {
  final muzzclient = MuzzClient();
  late final dynamic authProvider;

  @override
  void initState() {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StudioAddArtistButton(onTap: () { Navigator.of(context).pushNamed(studioCreateArtistScreenPath); }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        title: const Text("Studio"),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, value, child) => FutureBuilder<List<Artist>>(
          future: value.userArtists,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox(
                height: 150,
                width: 150,
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: snapshot.data!
                            .map(
                              (artist) => Column(
                                children: [
                                  ArtistsSliderItem(
                                    artist: artist,
                                    path: studioArtistScreenPath,
                                  ),
                                  const SizedBox(height: 50),
                                ],
                              ),
                            )
                            .toList(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}