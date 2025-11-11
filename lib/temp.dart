import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.dark;
  ThemeMode get mode => _mode;

  void toggle() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Library', style: textStyle.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () =>
                Provider.of<ThemeProvider>(context, listen: false).toggle(),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _tabButton(label: 'My Content', selected: false, theme: theme),
              const SizedBox(width: 8),
              _tabButton(label: 'Studio', selected: true, theme: theme),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: const [
                _ArtistTile(
                  image: 'assets/artist1.jpg',
                  name: 'Long Artist Name',
                ),
                SizedBox(height: 32),
                _ArtistTile(
                  image: 'assets/artist2.jpg',
                  name: 'Some artist',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('+ Add Artist'),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: 'Investments'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_music), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }

  Widget _tabButton({
    required String label,
    required bool selected,
    required ThemeData theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: selected
            ? theme.primaryColor
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          color: selected ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ArtistTile extends StatelessWidget {
  final String image;
  final String name;

  const _ArtistTile({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(image),
          radius: 50,
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: textStyle,
        ),
      ],
    );
  }
}
