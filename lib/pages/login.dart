import 'package:data_statement/pages/home.dart';
import 'package:data_statement/provider/toggle_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth/auth_service.dart';
import '../widgets/my_button.dart';
import '../widgets/my_text_field.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                sizedBoxHeight(50),
                Icon(
                  Icons.message,
                  size: 100,
                ),
                sizedBoxHeight(50),
                Text(
                  "Welcome back you\'ve been missed",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                sizedBoxHeight(25),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obcureText: false,
                ),
                sizedBoxHeight(10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obcureText: true,
                ),
                sizedBoxHeight(25),
                MyButton(
                    onTap: () async {
                      try {
                        await authService.signInWithEmailandPassword(
                            emailController.text, passwordController.text);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              e.toString(),
                            ),
                          ),
                        );
                      }
                    },
                    text: "Sign In"),
                sizedBoxHeight(50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Not a member?"),
                    sizedBoxWidth(4),
                    GestureDetector(
                      onTap: () => ref
                          .read(togglePress.notifier)
                          .update((state) => !state),
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox sizedBoxHeight(double height) {
    return SizedBox(
      height: height,
    );
  }

  SizedBox sizedBoxWidth(double width) {
    return SizedBox(
      width: width,
    );
  }
}
