import 'package:data_statement/pages/login.dart';
import 'package:data_statement/provider/toggle_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../pages/register.dart';

class LoginOrRegister extends ConsumerWidget {
  const LoginOrRegister({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(togglePress)) {
      return LoginPage();
    } else {
      return RegisterPage();
    }
  }
}
