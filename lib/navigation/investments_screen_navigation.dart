import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/consts/paths.dart';
import 'package:muzzbirzha_mobile/screens/artist_screen.dart';
import 'package:muzzbirzha_mobile/screens/investments_screen.dart';

class InvestmentsScreenNavigation extends StatefulWidget {
  const InvestmentsScreenNavigation({super.key});

  @override
  State<InvestmentsScreenNavigation> createState() => _InvestmentsScreenNavigationState();
}

class _InvestmentsScreenNavigationState extends State<InvestmentsScreenNavigation> {
  final GlobalKey<NavigatorState> investmentsScreenNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: investmentsScreenNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            if (settings.name == artistScreenPath) {
              final artistId = settings.arguments as int;
              return ArtistScreen(artistId: artistId);
            }
            return const InvestmentsScreen();
          },
        );
      },
    );
  }
}
