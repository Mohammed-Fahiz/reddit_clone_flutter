import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/Theme/pallette.dart';

import '../../features/auth/controller/auth_controller.dart';
import '../constants/constants.dart';
import '../global variables/global_variables.dart';

class GoogleSignInButton extends ConsumerWidget {
  final BuildContext mainContext;
  const GoogleSignInButton({super.key, required this.mainContext});

  void signInWithGoogle(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(mainContext);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallete.greyColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: Size(deviceWidth * .9, deviceHeight * .07),
      ),
      onPressed: () => signInWithGoogle(ref),
      icon: Image.asset(
        Constants.googleLogoPath,
        width: deviceWidth * .1,
      ),
      label: const Text("Continue with google"),
    );
  }
}
