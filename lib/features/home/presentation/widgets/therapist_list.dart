import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/features/home/controller/therapist_controller.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';

import '../../../../core/utils/sizes.dart';

class TherapistList extends StatefulWidget {
  const TherapistList({super.key});

  @override
  State<TherapistList> createState() => _TherapistListState();
}

class _TherapistListState extends State<TherapistList> {
  String? selectedTime;
  String? selectedDate;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            FirebaseQueryHelper.getCollectionsAsStream(collectionPath: "users"),
        builder: (context, snapshot) {
          final therapist = snapshot.data?.docs
              .where((element) => element.data()['isTherapist'] == true);
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: therapist?.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data?.docs[index].data();
                      String? url = item?['photoUrl'];
                      String? id = item?['uid'];
                      return ListTile(
                        leading: CachedNetworkImage(
                          height: maxWidth(context) * 0.12,
                          width: maxWidth(context) * 0.12,
                          fit: BoxFit.cover,
                          imageUrl: url ?? "",
                          errorWidget: (context, url, error) {
                            return Image.asset("assets/images/profile.png");
                          },
                          imageBuilder: (context, provider) {
                            return Container(
                              height: maxWidth(context) * 0.12,
                              width: maxWidth(context) * 0.12,
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
                        ),
                        title: Text(
                          "${item?['username']}",
                        ),
                        subtitle: Text(
                          "${item?['email']}",
                        ),
                        trailing: StreamBuilder(
                            stream: therapistController.getAllBookings(
                                uid: FirebaseAuth.instance.currentUser!.uid,
                                therapistID: id!),
                            builder: (context, snapshot) {
                              bool isBookedAlready =
                                  snapshot.data?.data() != null;
                              return TextButton(
                                onPressed: isBookedAlready
                                    ? () {}
                                    : () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return StatefulBuilder(
                                                builder: (context, setState) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Select date and time"),
                                                content: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        selectedTime = null;
                                                        setState(() {});
                                                        final time =
                                                            await showTimePicker(
                                                                context:
                                                                    context,
                                                                initialTime:
                                                                    TimeOfDay
                                                                        .now());
                                                        selectedTime = time
                                                            ?.format(context);
                                                        setState(() {});
                                                      },
                                                      child: Text(
                                                          selectedTime ??
                                                              "Select Time"),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        selectedDate = null;
                                                        final date = await showDatePicker(
                                                            context: context,
                                                            firstDate: DateTime
                                                                    .now()
                                                                .subtract(
                                                                    const Duration(
                                                                        days:
                                                                            1)),
                                                            lastDate: DateTime
                                                                    .now()
                                                                .add(const Duration(
                                                                    days: 2)));
                                                        setState(() {
                                                          selectedDate = DateFormat(
                                                                  "EEEE, MMM d")
                                                              .format(date!);
                                                        });
                                                      },
                                                      child: Text(
                                                          selectedDate ??
                                                              "Select Date"),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      selectedTime = null;
                                                      selectedDate = null;
                                                      setState(() {});
                                                    },
                                                    child: const Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      if (selectedDate !=
                                                              null &&
                                                          selectedTime !=
                                                              null) {
                                                        await therapistController
                                                            .onTherapistBookingRequest(
                                                                time:
                                                                    selectedDate!,
                                                                date:
                                                                    selectedDate!,
                                                                username: FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .displayName!,
                                                                uid: FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                                therapistID: id)
                                                            .then((value) =>
                                                                Navigator.pop(
                                                                    context));
                                                      }
                                                    },
                                                    child:
                                                        const Text("Request"),
                                                  ),
                                                ],
                                              );
                                            });
                                          },
                                        );
                                      },
                                child: StreamBuilder(
                                    stream: therapistController.getAllBookings(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        therapistID: id),
                                    builder: (context, snapshot) {
                                      bool isBookedAlready =
                                          snapshot.data?.data() != null;
                                      return isBookedAlready
                                          ? Text("Booked", style: kStyle18)
                                          : const Text("Book");
                                    }),
                              );
                            }),
                      );
                    },
                  ),
                );
        });
  }
}
