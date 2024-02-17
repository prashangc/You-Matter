import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/profile/presentation/widget/menu.dart';
import 'package:you_matter/features/profile/presentation/widget/profile.dart';
import 'package:you_matter/features/profile/presentation/widget/profile_app_bar.dart';

import '../../../../services/firebase/firebase_query_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final displayNameController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ColorConstant.kPrimary,
        automaticallyImplyLeading: false,
        toolbarHeight: 0.0,
      ),
      backgroundColor: ColorConstant.backgroundColor,
      body: SizedBox(
        width: maxWidth(context),
        height: maxHeight(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myAppBar(context),
            Flexible(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: ColorConstant.kPrimary,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            )),
                        width: maxWidth(context),
                        height: 50.0,
                      ),
                    ],
                  ),
                  Positioned(
                    top: 25.0,
                    bottom: 25.0,
                    left: 20.0,
                    right: 20.0,
                    child: StreamBuilder(
                        stream: FirebaseQueryHelper.getSingleDocumentAsStream(
                            collectionPath: 'users', docID: user?.uid ?? ""),
                        builder: (context, snapshot) {
                          Map<String, dynamic>? data = snapshot.data?.data();
                          return Column(
                            children: [
                              profile(context, data),
                              sizedBox16(),
                              menu(context, data),
                            ],
                          );
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
