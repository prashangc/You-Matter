import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:you_matter/core/route/route.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/dashboard/presentation/ui/base.dart';
import 'package:you_matter/features/login/presentation/ui/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? fadeInAnimation;
  Animation<Offset>? slideAnimation;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController!, curve: Curves.easeIn),
    );
    slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
      CurvedAnimation(parent: animationController!, curve: Curves.easeInOut),
    );
    animationController!.forward();

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
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.kBackgroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        width: maxWidth(context),
        height: maxHeight(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: fadeInAnimation!,
              child: Image.asset(
                'assets/images/logo.png',
                width: maxWidth(context) / 2.5,
                height: maxHeight(context) / 5,
              ),
            ),
            sizedBox16(),
            SlideTransition(
              position: slideAnimation!,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You',
                    style: kStyle12B.copyWith(fontSize: 30.0),
                  ),
                  Text(
                    'Matter',
                    style: kStyle12B.copyWith(fontSize: 30.0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        height: 80.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Text(
                'You Matter',
                style: kStyle12B.copyWith(color: ColorConstant.kPrimary),
              ),
            ),
            sizedBox8(),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Text(
                "Powered By: You Matter",
                style: kStyle12B,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
