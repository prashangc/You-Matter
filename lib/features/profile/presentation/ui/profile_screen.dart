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
import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/profile/presentation/widget/menu.dart';
import 'package:you_matter/features/profile/presentation/widget/profile.dart';
import 'package:you_matter/features/profile/presentation/widget/profile_app_bar.dart';

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
            myAppBar(),
            Expanded(
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
                      Expanded(
                        child: Container(
                          width: maxWidth(context),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 25.0,
                    bottom: 25.0,
                    left: 20.0,
                    right: 20.0,
                    child: Column(
                      children: [
                        profile(context),
                        sizedBox16(),
                        menu(context),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),

      // Center(
      //   child: Column(
      //     mainAxisSize: MainAxisSize.max,
      //     children: [
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         children: [
      //           Container(
      //             padding: const EdgeInsets.all(8),
      //             height: maxWidth(context) * 0.3,
      //             width: maxWidth(context) * 0.3,
      //             decoration: const BoxDecoration(
      //               shape: BoxShape.circle,
      //               color: Colors.grey,
      //             ),
      //             child: Stack(
      //               children: [
      //                 const Center(
      //                   child: CircleAvatar(
      //                     radius: 55,
      //                     backgroundImage:
      //                         AssetImage("assets/images/profile.png"),
      //                   ),
      //                 ),
      //                 Align(
      //                   alignment: Alignment.bottomRight,
      //                   child: InkWell(
      //                     onTap: () async {
      //                       final imagePicker = ImagePicker();
      //                       XFile? image;

      //                       final permissionStatus =
      //                           await Permission.mediaLibrary.isGranted ||
      //                               await Permission.mediaLibrary.isLimited;
      //                       if (permissionStatus) {
      //                         image = await imagePicker.pickImage(
      //                             source: ImageSource.gallery, imageQuality: 5);
      //                         if (image != null) {
      //                           // print(image.path);
      //                           // image.
      //                           // user?.updatePhotoURL(photoURL)
      //                           // await imageCompressUseCase.compressImage(image.path, (file) {
      //                           //   compressedImage(file);
      //                           // });
      //                           // compressedImage(File(image.path));
      //                         }
      //                       } else {
      //                         bool hasPermission = await Permission.mediaLibrary
      //                                 .request()
      //                                 .isGranted ||
      //                             await Permission.mediaLibrary
      //                                 .request()
      //                                 .isLimited;
      //                         if (hasPermission) {
      //                           image = await imagePicker.pickImage(
      //                               source: ImageSource.gallery);
      //                           if (image != null) {
      //                             // print(image.path);
      //                             // await imageCompressUseCase.compressImage(image.path, (file) {
      //                             //   compressedImage(file);
      //                             // });
      //                             // compressedImage(File(image.path));
      //                           }
      //                         }
      //                       }
      //                     },
      //                     child: const Icon(
      //                       Icons.photo,
      //                     ),
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ),
      //           const SizedBox(
      //             width: 20,
      //           ),
      //           Row(
      //             crossAxisAlignment: CrossAxisAlignment.end,
      //             children: [
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                       FirebaseAuth.instance.currentUser?.displayName ??
      //                           "User",
      //                       style: kStyle18B),
      //                   Text(FirebaseAuth.instance.currentUser?.email ?? "N/A",
      //                       style: kStyle12),
      //                 ],
      //               ),
      //               IconButton(
      //                   onPressed: () {
      //                     showDialog(
      //                       context: context,
      //                       builder: (context) {
      //                         return AlertDialog(
      //                           title: const Text("Update"),
      //                           content: Column(
      //                             mainAxisSize: MainAxisSize.min,
      //                             children: [
      //                               TextField(
      //                                 controller: displayNameController,
      //                                 decoration: const InputDecoration(
      //                                   hintText: "Display Name",
      //                                   border: OutlineInputBorder(),
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                           actions: [
      //                             TextButton(
      //                               onPressed: () {
      //                                 Navigator.pop(context);
      //                               },
      //                               child: const Text("Cancel"),
      //                             ),
      //                             TextButton(
      //                               onPressed: () async {
      //                                 final displayName =
      //                                     displayNameController.text;

      //                                 if (displayName.isNotEmpty) {
      //                                   await user
      //                                       ?.updateDisplayName(displayName);
      //                                 }
      //                                 Navigator.pop(context);
      //                                 displayNameController.clear();
      //                               },
      //                               child: const Text("Update"),
      //                             )
      //                           ],
      //                         );
      //                       },
      //                     );
      //                   },
      //                   icon: const Icon(Icons.edit))
      //             ],
      //           ),
      //         ],
      //       ),
      //       // StreamBuilder(stream: stream, builder: builder)

      //       ElevatedButton(
      //           onPressed: () async {
      //             await FirebaseAuth.instance.signOut().then((value) async {
      //               final preference = await SharedPreferences.getInstance();
      //               await preference.remove("uid");
      //               pushAndRemoveUpto(
      //                   context: context, screen: const LoginScreen());
      //             });
      //           },
      //           child: const Text("Logout")),
      //       ElevatedButton(
      //           onPressed: () async {
      //             await user?.updateDisplayName("Test User");
      //           },
      //           child: const Text("Update Display Name")),
      //     ],
      //   ),
      // ),
    );
  }
}
