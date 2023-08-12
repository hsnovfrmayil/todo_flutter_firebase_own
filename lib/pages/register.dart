import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_statement/services/auth/auth_service.dart';
import 'package:data_statement/services/image_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../provider/toggle_page.dart';
import '../widgets/my_button.dart';
import '../widgets/my_text_field.dart';

class RegisterPage extends ConsumerWidget {
  RegisterPage({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final authService = AuthService();
 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      sizedBoxHeight(MediaQuery.of(context).size.height / 7),
                      Column(
                        children: [
                          Stack(
                            children: [
                              const CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                    "https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg"),
                              ),
                              Positioned(
                                bottom: -10,
                                right: -10,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.add_a_photo),
                                ),
                              )
                            ],
                          )
                        ],
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
                      sizedBoxHeight(10),
                      MyTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm password',
                        obcureText: true,
                      ),
                      sizedBoxHeight(25),
                      MyButton(
                          onTap: () async {
                            if (passwordController.text !=
                                confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Passwords do not match!"),
                                ),
                              );
                              return;
                            }
                            try {
                              await authService.signUpWithEmailandPassword(
                                  emailController.text,
                                  passwordController.text);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                          text: "Sign Up"),
                      sizedBoxHeight(50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already a member?"),
                          sizedBoxWidth(4),
                          GestureDetector(
                            onTap: () => ref
                                .read(togglePress.notifier)
                                .update((state) => !state),
                            child: Text(
                              "Login now",
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
          ],
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
