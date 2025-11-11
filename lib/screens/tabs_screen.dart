import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:muzzbirzha_mobile/navigation/home_screen_navigation.dart';
import 'package:muzzbirzha_mobile/navigation/library_screen_navigation.dart';
import 'package:muzzbirzha_mobile/navigation/investments_screen_navigation.dart';
import 'package:muzzbirzha_mobile/providers/track_list_provider.dart';
import 'package:muzzbirzha_mobile/screens/investments_screen.dart';
import 'package:muzzbirzha_mobile/screens/me_screen.dart';
import 'package:muzzbirzha_mobile/widgets/main_bottom_navigation_bar.dart';
import 'package:muzzbirzha_mobile/widgets/mini_player/muzz_mini_player.dart';
import 'package:provider/provider.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _currentTabIndex = 0;
  List<Widget> _screens = [];

  late final dynamic trackListProvider;

  // final List<GlobalKey<NavigatorState>> _navigatorKeys = [
  //   homeScreenNavigatorKey,
  // ];

  // Future<bool> _systemBackButtonPressed() async {
  //   if (_navigatorKeys[_currentTabIndex].currentState?.canPop() == true) {
  //     _navigatorKeys[_currentTabIndex]
  //         .currentState
  //         ?.pop(_navigatorKeys[_currentTabIndex].currentContext);

  //     return false;
  //   } else {
  //     SystemChannels.platform.invokeListMethod<void>("SystemNavigator.pop");
  //     return false;
  //   }
  // }

  @override
  void initState() {
    super.initState();

    _currentTabIndex = 0;
    _screens = [
      const HomeScreenNavigation(),
      const InvestmentsScreenNavigation(),
      const LibraryScreenNavigation(),
      const MeScreen(),
    ];

    trackListProvider = Provider.of<TrackListProvider>(context, listen: false);
  }

  void onTabTapped(int index) {
    setState(() {
      _currentTabIndex = index;
      trackListProvider.miniPlayerController
          .animateToHeight(state: PanelState.MIN);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<TrackListProvider>(
          builder: (context, value, child) => Stack(
            children: _screens
                .asMap()
                .map(
                  (i, screen) => MapEntry(
                    i,
                    Offstage(
                      offstage: i != _currentTabIndex,
                      child: screen,
                    ),
                  ),
                )
                .values
                .toList()
              ..add(
                Offstage(
                  offstage: value.currentTrackIndex == null,
                  child: value.currentTrackIndex == null
                      ? const SizedBox.shrink()
                      : const MuzzMiniPlayer(),
                ),
              ),
          ),
        ),
        bottomNavigationBar: MainBottomNavigationBar(
          currentTabIndex: _currentTabIndex,
          onTabTapped: onTabTapped,
        ));
  }
}
