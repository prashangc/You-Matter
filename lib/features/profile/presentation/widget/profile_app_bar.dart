import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:you_matter/core/route/route.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/login/presentation/ui/login.dart';

Widget myAppBar(context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    color: ColorConstant.kPrimary,
    child: Column(
      children: [
        sizedBox16(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '  Profile',
              style: kStyle18B.copyWith(
                color: ColorConstant.kWhite,
                fontSize: 24.0,
              ),
            ),
            GestureDetector(
              onTap: () async {
                FirebaseAuth.instance.signOut();

                final preference = await SharedPreferences.getInstance();
                preference.clear();
                pushAndRemoveUpto(
                    context: context, screen: const LoginScreen());
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: ColorConstant.kRed,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(24.0))),
                child: Row(
                  children: [
                    sizedBox2(),
                    Text(
                      'Logout',
                      style: kStyle12.copyWith(color: ColorConstant.kWhite),
                    ),
                    sizedBox12(),
                    CircleAvatar(
                      radius: 14.0,
                      backgroundColor: ColorConstant.kWhite.withOpacity(0.6),
                      child: const Icon(
                        Icons.logout_outlined,
                        size: 15.0,
                      ),
                    ),
                    sizedBox2(),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    ),
  );
}
