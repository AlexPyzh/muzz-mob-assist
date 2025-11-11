import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      title: Text(
        "MUZZ FUND",
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          iconSize: 40.0,
          onPressed: () {},
        ),
      ],
    );
  }
}
