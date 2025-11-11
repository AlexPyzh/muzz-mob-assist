import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';
import 'package:muzzbirzha_mobile/providers/auth_provider.dart';
import 'package:muzzbirzha_mobile/providers/invest_provider.dart';
import 'package:muzzbirzha_mobile/providers/studio_provider.dart';
import 'package:muzzbirzha_mobile/providers/track_list_provider.dart';
import 'package:muzzbirzha_mobile/screens/auth_screen.dart';
import 'package:muzzbirzha_mobile/screens/tabs_screen.dart';
import 'package:provider/provider.dart';

// final theme = ThemeData(
//   useMaterial3: true,
//   colorScheme: ColorScheme.fromSeed(
//     brightness: Brightness.dark,
//     seedColor: Colors.black,
//     surface: Colors.black,
//   ),
//   textTheme: GoogleFonts.latoTextTheme(),
// );

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => TrackListProvider()),
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => StudioProvider()),
      ChangeNotifierProvider(create: (context) => InvestProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: theme,
      theme: MuzzTheme.dark,
      home: const AuthScreen(),
    );
  }
}
