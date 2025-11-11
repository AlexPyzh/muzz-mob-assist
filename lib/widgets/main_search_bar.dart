import 'package:flutter/material.dart';

class MainSearchBar extends StatefulWidget {
  const MainSearchBar({super.key});

  @override
  State<StatefulWidget> createState() => _MainSearchBarState();
}

class _MainSearchBarState extends State<MainSearchBar> {
  double width = 65;

  void extendSearchInput() {
    setState(() {
      width = 350;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
      return SearchBar(
        constraints: BoxConstraints(maxWidth: width, minHeight: 45),
        controller: controller,
        padding: const MaterialStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 16),
        ),
        onTap: () {
          controller.openView();
        },
        onChanged: (_) {
          controller.openView();
        },
        onSubmitted: (_) {
          setState(() {
            controller.closeView(_);
            width = 350;
          });
          // extendSearchInput;
        },
        leading: const Icon(Icons.search),
      );
    }, suggestionsBuilder: (BuildContext context, SearchController controller) {
      return List<ListTile>.generate(5, (int index) {
        final String item = 'item $index';
        return ListTile(
          title: Text(item),
          onTap: () {
            setState(() {
              controller.closeView(item);
            });
          },
        );
      });
    });
  }
}
