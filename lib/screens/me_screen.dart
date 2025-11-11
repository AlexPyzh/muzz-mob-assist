import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/providers/auth_provider.dart';
import 'package:muzzbirzha_mobile/widgets/auth_screen/auth_text_field.dart';
import 'package:muzzbirzha_mobile/widgets/global_using_widgets.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  late final dynamic authProvider;
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    nameController.text = authProvider.loggedInUser.name;
    emailController.text = authProvider.loggedInUser.email;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            "${authProvider.loggedInUser.name}",
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AuthTextField( 
                  controller: nameController,
                  hintText: "Name",
                  isObscured: false,
                  keboardType: TextInputType.none,
                ),
                const SizedBox(height: 10),
                AuthTextField( 
                  controller: emailController,
                  hintText: "Email",
                  isObscured: false,
                  keboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
