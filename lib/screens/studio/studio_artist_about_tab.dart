import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/artist.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';
import 'package:muzzbirzha_mobile/providers/studio_provider.dart';
import 'package:provider/provider.dart';

class StudioArtistAboutTab extends StatefulWidget {
  const StudioArtistAboutTab({super.key});

  @override
  State<StudioArtistAboutTab> createState() => _StudioArtistAboutTabState();
}

class _StudioArtistAboutTabState extends State<StudioArtistAboutTab> {
  final TextEditingController _aboutController = TextEditingController();
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadAboutText();
  }

  void _loadAboutText() {
    final artist = context.read<StudioProvider>().artist;
    if (artist?.about != null) {
      _aboutController.text = artist!.about!;
    }
  }

  Future<void> _saveAbout() async {
    setState(() => _isSaving = true);

    try {
      final studioProvider = context.read<StudioProvider>();
      final artist = studioProvider.artist;

      if (artist != null) {
        // Обновляем about текст через API
        final updatedArtist = Artist(
          id: artist.id,
          name: artist.name,
          about: _aboutController.text.trim(),
          imageUrl: artist.imageUrl,
        );

        final response = await MuzzClient().updateArtist(updatedArtist);

        if (response.success == true && response.data != null) {
          // Обновляем локальное состояние
          studioProvider.artist = response.data;

          setState(() {
            _isEditing = false;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('About text saved successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          throw Exception(response.message ?? 'Failed to save');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _loadAboutText(); // Восстанавливаем исходный текст
    });
  }

  @override
  void dispose() {
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final artist = context.watch<StudioProvider>().artist;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'About ${artist?.name ?? 'Artist'}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (!_isEditing)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white70),
                  onPressed: () {
                    setState(() => _isEditing = true);
                  },
                )
              else
                Row(
                  children: [
                    if (_isSaving)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    else ...[
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: _saveAbout,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: _cancelEditing,
                      ),
                    ],
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isEditing ? Colors.blue : Colors.grey[800]!,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isEditing
                  ? TextField(
                      controller: _aboutController,
                      maxLines: null,
                      minLines: 10,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.5,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter information about the artist...',
                        hintStyle: TextStyle(color: Colors.white38),
                        border: InputBorder.none,
                      ),
                      autofocus: true,
                    )
                  : InkWell(
                      onTap: () {
                        setState(() => _isEditing = true);
                      },
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 200),
                        child: _aboutController.text.isEmpty
                            ? const Text(
                                'No information added yet. Tap to add...',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            : Text(
                                _aboutController.text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                      ),
                    ),
            ),
          ),
          if (!_isEditing) ...[
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Tap the edit icon or the text to modify',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
