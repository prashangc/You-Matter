import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:you_matter/core/route/route.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/core/utils/text_form_field.dart';
import 'package:you_matter/features/login/presentation/ui/login.dart';

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
        title: const Text("Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  height: maxWidth(context) * 0.3,
                  width: maxWidth(context) * 0.3,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: CircleAvatar(
                          radius: 55,
                          backgroundImage:
                              AssetImage("assets/images/profile.png"),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.photo,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            FirebaseAuth.instance.currentUser?.displayName ??
                                "User",
                            style: kStyle18B),
                        Text(FirebaseAuth.instance.currentUser?.email ?? "N/A",
                            style: kStyle12),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
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
                                      final displayName =
                                          displayNameController.text;

                                      if (displayName.isNotEmpty) {
                                        await user
                                            ?.updateDisplayName(displayName);
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
                        icon: const Icon(Icons.edit))
                  ],
                ),
              ],
            ),
            // StreamBuilder(stream: stream, builder: builder)

            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) async {
                    final preference = await SharedPreferences.getInstance();
                    await preference.remove("uid");
                    pushAndRemoveUpto(
                        context: context, screen: const LoginScreen());
                  });
                },
                child: const Text("Logout")),
            ElevatedButton(
                onPressed: () async {
                  await user?.updateDisplayName("Test User");
                },
                child: const Text("Update Display Name")),
          ],
        ),
      ),
    );
  }
}
