import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:you_matter/core/route/route.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/core/utils/time_utils.dart';
import 'package:you_matter/features/dashboard/presentation/ui/base.dart';
import 'package:you_matter/features/questions/presentation/ui/question_screen.dart';

import '../../services/firebase/firebase_query_handler.dart';
import '../login/presentation/ui/login.dart';

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
      if (FirebaseAuth.instance.currentUser?.uid != null) {
        await removeOldDatas();
      }
      final preference = await SharedPreferences.getInstance();
      String? uid = preference.getString("uid");
      bool? isTherapist = preference.getBool("isTherapist");
      if (uid != null) {
        pushAndRemoveUpto(
            context: context,
            screen: BasePage(
              currentIndex: 0,
              isTherapist: isTherapist ?? false,
            ));
      } else {
        pushAndRemoveUpto(
            context: context,
            screen: const QuestionAnswerScreen(
              isOnboarding: true,
            ));

        // pushTo(context: context, screen: const LoginScreen());
      }
    });
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  Future<void> removeOldDatas() async {
    await removeOldBookings();
    await removeOldTimes();
  }

  Future<void> removeOldBookings() async {
    final allBookings = await FirebaseQueryHelper.firebaseFireStore
        .collection('bookings')
        .get();
    for (QueryDocumentSnapshot element in allBookings.docs) {
      final data = element.data() as Map<String, dynamic>?;
      bool isNotToday =
          data?['date'] != DateFormat("EEEE, MMM d").format(DateTime.now());
      DateTime endTime = parseTimeString(data?['endTime']);
      final current = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
      bool appointmentEnded = current.isAfter(endTime);
      if (isNotToday || appointmentEnded) {
        await element.reference.delete();
      }
    }
  }

  Future<void> removeOldTimes() async {
    final allTimes = await FirebaseQueryHelper.firebaseFireStore
        .collection('time')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    final filteredTime = allTimes.data()?['times'] as List<dynamic>?;
    List<dynamic> previous = [];
    if (filteredTime != null && filteredTime.isNotEmpty) {
      previous = filteredTime
          .map((e) => {
                'isBooked': e['isBooked'],
                'scheduleID': e['scheduleID'],
                'startTime': e['startTime'],
                'endTime': e['endTime'],
                'createdOn': e['createdOn']
              })
          .toList();
    }
    previous.removeWhere((e) {
      final test = e as Map<String, dynamic>?;
      bool isNotToday = test?['createdOn'] !=
          DateFormat("EEEE, MMM d").format(DateTime.now());
      return isNotToday;
    });
    FirebaseQueryHelper.firebaseFireStore
        .collection('time')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({'times': previous});
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
