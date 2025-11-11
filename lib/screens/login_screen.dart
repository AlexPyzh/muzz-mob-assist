import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/http_models/login_request.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';
import 'package:muzzbirzha_mobile/providers/auth_provider.dart';
import 'package:muzzbirzha_mobile/widgets/auth_screen/auth_text_field.dart';
import 'package:muzzbirzha_mobile/widgets/auth_screen/auth_button.dart';
import 'package:muzzbirzha_mobile/widgets/auth_screen/square_img_tile.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.onTap, super.key});

  final Function()? onTap;

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final dynamic authProvider;
  final _muzzClient = MuzzClient();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      login();

      Navigator.pop(context);
    } on Exception catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.toString());
    }
  }

  void login() async {
    var loginRequest = LoginRequest(
      email: emailController.text,
      password: passwordController.text,
    );

    var loginResponse = await _muzzClient.login(loginRequest);
    if (loginResponse.success!) {
      authProvider.token = loginResponse.data;
      authProvider.isLoggedIn = true;
    }
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
      backgroundColor: Colors.grey[950],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome back, let\'s rock again!",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 25),
                AuthTextField(
                  controller: emailController,
                  hintText: "Email",
                  isObscured: false,
                  keboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                AuthTextField(
                  controller: passwordController,
                  hintText: "Password",
                  isObscured: true,
                  keboardType: TextInputType.text,
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Forgot password",
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Colors.white70,
                                  )),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                SignInButton(caption: "Im here", onTap: signUserIn),
                const SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.white70,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Or continue with",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareImgTile(imagePath: "lib/assets/img/google.png"),
                    SizedBox(width: 10),
                    SquareImgTile(imagePath: "lib/assets/img/apple.png"),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Not a member yet?",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register now",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
