import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:you_matter/core/route/route.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/login/presentation/ui/login.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';
import 'package:you_matter/services/state/state_bloc.dart';

Widget introCard(context, StateHandlerBloc chatStateBloc) {
  return Column(
    children: [
      sizedBox16(),
      Text(
        'Hello,',
        style: kStyle12.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      sizedBox2(),
      FutureBuilder(
          future: FirebaseQueryHelper.getSingleDocument(
              collectionPath: 'users',
              docID: FirebaseAuth.instance.currentUser?.uid ?? ""),
          builder: (c, snapshot) {
            Map<String, dynamic>? data =
                snapshot.data?.data() as Map<String, dynamic>?;
            return snapshot.connectionState == ConnectionState.waiting
                ? const SizedBox.shrink()
                : Text(
                    snapshot.hasError ? 'Guest' : data?['username'] ?? 'Guest',
                    style: kStyle12.copyWith(
                      fontSize: 22.0,
                      color: ColorConstant.kBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  );
          }),
      sizedBox24(),
      Text(
        'How can we help you today?',
        style: kStyle12.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      sizedBox12(),
      Text(
        'We are at your service 24 * 7',
        style: kStyle12,
      ),
      sizedBox12(),
      Hero(
        tag: 'chatbot',
        child: Image.asset(
          'assets/gif/chatbot.gif',
        ),
      ),
      sizedBox12(),
      GestureDetector(
        onTap: () => chatStateBloc.storeData(data: 1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            color: ColorConstant.kPrimary,
          ),
          alignment: Alignment.center,
          child: Text(
            'Click Here To Find Therapist you need',
            style: kStyle18B.copyWith(color: ColorConstant.kWhite),
          ),
        ),
      ),
      sizedBox24(),
      Container(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () => pushTo(context: context, screen: const LoginScreen()),
          child: Text(
            'Skip to login',
            style: kStyle14B,
          ),
        ),
      ),
    ],
  );
}
