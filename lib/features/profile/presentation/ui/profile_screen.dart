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
