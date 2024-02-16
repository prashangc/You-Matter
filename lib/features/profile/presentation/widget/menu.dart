import 'package:flutter/material.dart';
import 'package:you_matter/core/route/route.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/add_time/presentation/ui/add_time_screen.dart';
import 'package:you_matter/features/booking/presentation/ui/my_booking_screen.dart';

Widget menu(context, Map<String, dynamic>? data) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: ColorConstant.kWhite,
        boxShadow: [
          BoxShadow(color: ColorConstant.kGrey, offset: const Offset(3, 3))
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      child: Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              sizedBox8(),
              myCard(
                context: context,
                title: 'My Appointments',
                subtitle: 'View your appointment history',
                icon: Icons.health_and_safety_outlined,
                myTap: () {
                  pushTo(context: context, screen: const MyBookings());
                },
              ),
              myCard(
                context: context,
                title: 'Verify Email',
                icon: Icons.email_outlined,
                subtitle: 'Verify your email address',
                myTap: () {},
              ),
              myCard(
                context: context,
                title: 'Password and Security',
                subtitle: 'Change your security preferences',
                icon: Icons.security_outlined,
                myTap: () {},
              ),
              if (data?['isTherapist'] == true) ...{
                myCard(
                  context: context,
                  title: 'Schedule Time',
                  subtitle: 'Schedule your time for today',
                  icon: Icons.schedule,
                  myTap: () {
                    pushTo(context: context, screen: AddTimeScreen(data: data));
                  },
                )
              },
              myCard(
                context: context,
                myTap: () {},
                title: 'Biometrics',
                subtitle: 'Enable biometric login',
                icon: Icons.fingerprint_rounded,
                action: Switch(
                  value: true,
                  onChanged: (v) {},
                  activeColor: ColorConstant.kPrimary,
                  inactiveThumbColor: ColorConstant.kWhite,
                  inactiveTrackColor: ColorConstant.backgroundColor,
                  activeTrackColor: ColorConstant.backgroundColor,
                ),
              ),
              myCard(
                context: context,
                title: 'Language',
                myTap: () {},
                subtitle: 'Change application language',
                icon: Icons.language_sharp,
                action: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(24.0),
                    ),
                    border: Border.all(color: ColorConstant.kGrey),
                  ),
                  child: Row(
                    children: [
                      sizedBox8(),
                      const Text(
                        'Eng',
                      ),
                      sizedBox8(),
                      const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
              ),
              myCard(
                myTap: () {},
                context: context,
                title: 'Notifications',
                subtitle: 'Get notified with your preferences',
                icon: Icons.notifications_outlined,
                showDivider: false,
                action: Switch(
                  value: true,
                  onChanged: (v) {},
                  activeColor: ColorConstant.kPrimary,
                  inactiveThumbColor: ColorConstant.kWhite,
                  inactiveTrackColor: ColorConstant.backgroundColor,
                  activeTrackColor: ColorConstant.backgroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget myCard({
  required context,
  required String title,
  required String subtitle,
  required IconData icon,
  required Function myTap,
  bool? showDivider,
  Widget? action,
}) {
  return Container(
    width: maxWidth(context),
    margin: const EdgeInsets.only(bottom: 16.0),
    child: GestureDetector(
      onTap: () {
        myTap();
      },
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.0,
            color: ColorConstant.kPrimary,
          ),
          sizedBox24(),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizedBox12(),
                        Text(
                          title,
                          style: kStyle14B.copyWith(),
                        ),
                        sizedBox8(),
                        Text(
                          subtitle,
                          style: kStyle12.copyWith(),
                        ),
                        sizedBox12(),
                      ],
                    ),
                    action ??
                        const Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Icon(
                            Icons.keyboard_arrow_right_outlined,
                            size: 24.0,
                          ),
                        )
                  ],
                ),
                sizedBox8(),
                Container(
                  color: ColorConstant.kGrey,
                  height: showDivider != null ? 0.0 : 1.0,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
