
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:you_matter/core/route/route.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/login/presentation/ui/login.dart';
import 'package:you_matter/features/profile/controller/profile_controller.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';

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
                Stack(
                  children: [
                    ClipRRect(
                        child: StreamBuilder(
                            stream:
                                FirebaseQueryHelper.getSingleDocumentAsStream(
                                    collectionPath: 'users',
                                    docID: user?.uid ?? ""),
                            builder: (context, snapshot) {
                              Map<String, dynamic>? data =
                                  snapshot.data?.data();
                              String? url = data?['photoUrl'];
                              return CachedNetworkImage(
                                height: maxWidth(context) * 0.25,
                                width: maxWidth(context) * 0.25,
                                fit: BoxFit.cover,
                                imageUrl: url ?? "",
                                errorWidget: (context, url, error) {
                                  return Image.asset(
                                      "assets/images/profile.png");
                                },
                                imageBuilder: (context, provider) {
                                  return Container(
                                    height: maxWidth(context) * 0.25,
                                    width: maxWidth(context) * 0.25,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: provider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                                placeholder: (context, url) {
                                  return const CircularProgressIndicator();
                                },
                              );
                            })),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () async {
                          await profileController.onUpdateProfile(user);
                        },
                        child: const Icon(
                          Icons.photo,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    StreamBuilder(
                      stream: FirebaseQueryHelper.getSingleDocumentAsStream(
                          collectionPath: 'users', docID: user?.uid ?? ""),
                      builder: (context, snapshot) {
                        Map<String, dynamic>? data = snapshot.data?.data();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data?['username'] ?? "User", style: kStyle18B),
                            Text(data?['email'] ?? "N/A", style: kStyle12),
                          ],
                        );
                      },
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
                                        FirebaseQueryHelper.firebaseFireStore
                                            .collection("users")
                                            .doc(user?.uid)
                                            .update({'username': displayName});
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
          ],
        ),
      ),
    );
  }
}
