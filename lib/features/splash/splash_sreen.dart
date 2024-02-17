import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:you_matter/core/route/route.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/dashboard/presentation/ui/base.dart';
import 'package:you_matter/features/login/presentation/ui/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      final preference = await SharedPreferences.getInstance();
      String? uid = preference.getString("uid");
      bool? isTherapist = preference.getBool("isTherapist");
      if (uid != null) {
        pushTo(
            context: context,
            screen: BasePage(
              currentIndex: 0,
              isTherapist: isTherapist ?? false,
            ));
      } else {
        pushTo(context: context, screen: const LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.kPrimary,
      body: Center(
        child: FlutterLogo(
          size: maxWidth(context) / 4,
        ),
      ),
    );
  }
}
