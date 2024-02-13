import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';

Widget profile(context) {
  final displayNameController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  return Container(
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: ColorConstant.kWhite,
      boxShadow: [
        BoxShadow(color: ColorConstant.kGrey, offset: const Offset(3, 3))
      ],
      borderRadius: const BorderRadius.all(
        Radius.circular(30.0),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage("assets/images/profile.png"),
        ),
        sizedBox16(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FirebaseAuth.instance.currentUser?.displayName ?? "User",
                style: kStyle14B,
              ),
              Text(
                FirebaseAuth.instance.currentUser?.email ?? "N/A",
                style: kStyle12,
              ),
            ],
          ),
        ),
        sizedBox16(),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Update"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: displayNameController,
                            decoration: const InputDecoration(
                              hintText: "Display Name",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            final displayName = displayNameController.text;

                            if (displayName.isNotEmpty) {
                              await user?.updateDisplayName(displayName);
                            }
                            Navigator.pop(context);
                            displayNameController.clear();
                          },
                          child: const Text("Update"),
                        )
                      ],
                    );
                  },
                );
              },
              child: Text(
                'Edit',
                style: kStyle14B.copyWith(color: ColorConstant.kOrange),
              ),
            ),
            sizedBox8(),
            Icon(
              Icons.edit,
              color: ColorConstant.kOrange,
              size: 14.0,
            )
          ],
        )
      ],
    ),
  );
}
