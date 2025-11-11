import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/playlist.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';
import 'package:muzzbirzha_mobile/providers/auth_provider.dart';
import 'package:muzzbirzha_mobile/widgets/playlists_list/playlists_list_grid.dart';
import 'package:muzzbirzha_mobile/widgets/personal_pl_screen/dialog_text_field.dart';
import 'package:provider/provider.dart';

class PersonalPlListScreen extends StatefulWidget {
  const PersonalPlListScreen({
    super.key,
    required this.appBarTitle,
    required this.playlists,
  });

  final String appBarTitle;
  final List<Playlist> playlists;

  @override
  State<PersonalPlListScreen> createState() => _PersonalPlListScreenState();
}

class _PersonalPlListScreenState extends State<PersonalPlListScreen> {
  final _muzzClient = MuzzClient();
  final Playlist newPlaylist = Playlist();
  final playlistNameController = TextEditingController();
  final playlistDescriptionController = TextEditingController();
  bool isPublicPlaylist = false;
  late final dynamic authProvider;

  @override
  void initState() {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  void addPersonalPLaylist() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      createPlaylist();
      Navigator.of(context).pop;
    } on Exception catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.toString());
    }
  }

  void createPlaylist() {
    newPlaylist.userId = authProvider.loggedInUser.id;
    newPlaylist.name = playlistNameController.text;
    newPlaylist.description = playlistDescriptionController.text;
    newPlaylist.created = DateTime.now();
    newPlaylist.public = isPublicPlaylist;

    _muzzClient.createPersonalPlaylist(newPlaylist);
  }

  void showErrorMessage(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.purple,
            title: Center(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appBarTitle,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _dialogBuilder(context),
          ),
        ],
      ),
      body: PlayListsListGrid(
        playlists: widget.playlists,
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Create playlist',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DialogTextField(
                  controller: playlistNameController,
                  hintText: "Name",
                ),
                DialogTextField(
                  controller: playlistDescriptionController,
                  hintText: "Description",
                ),
                Row(
                  children: [
                    Text(
                      "Public",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white),
                    ),
                    Checkbox(
                      value: isPublicPlaylist,
                      onChanged: (value) {
                        setState(() {
                          isPublicPlaylist = value!;
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Create'),
              onPressed: () {
                addPersonalPLaylist();
                Navigator.of(context).pop;
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                playlistNameController.text = "";
                playlistDescriptionController.text = "";
                isPublicPlaylist = false;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
