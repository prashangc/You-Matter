import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:you_matter/core/route/route.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/focus_remover.dart';
import 'package:you_matter/core/utils/grid_view_delegate.dart';
import 'package:you_matter/core/utils/my_cached_network_image.dart';
import 'package:you_matter/core/utils/my_empty_card.dart';
import 'package:you_matter/core/utils/my_rating_bar.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/home/presentation/widgets/therapist_details.dart';
import 'package:you_matter/features/search/controller/algorithm.dart';
import 'package:you_matter/features/search/controller/search_controller.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? keyword;
  var matchingTherapist;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor,
      body: GestureDetector(
        onTap: () => myFocusRemover(context),
        child: SafeArea(
          child: Container(
            width: maxWidth(context),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            color: ColorConstant.backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedBox12(),
                searchBar(context),
                sizedBox12(),
                Expanded(
                    child: SingleChildScrollView(
                        child: searchTherapistList(context))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchBar(context) {
    return Row(
      children: [
        Container(
          width: 45,
          height: 50,
          decoration: BoxDecoration(
            color: ColorConstant.kWhite,
            borderRadius: BorderRadius.circular(8),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.keyboard_arrow_left_outlined,
              size: 28.0,
              color: Colors.grey[400],
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: TextFormField(
            controller: searchController.textEditingController,
            cursorColor: ColorConstant.kBackgroundColor,
            textCapitalization: TextCapitalization.words,
            style: kStyle12.copyWith(fontSize: 12.0, color: Colors.grey[400]),
            onChanged: (String? value) {
              setState(() {
                if (value == null || value == '') {
                  keyword = null;
                } else {
                  keyword = value;
                }
              });
            },
            onTap: () {},
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              filled: true,
              fillColor: ColorConstant.kWhite,
              prefixIcon: Icon(
                Icons.search,
                size: 17,
                color: Colors.grey[400],
              ),
              suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      keyword = null;
                      searchController.textEditingController.clear();
                    });
                  },
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.grey[400],
                  )),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
                borderSide: BorderSide(color: ColorConstant.kWhite, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
                borderSide:
                    BorderSide(color: ColorConstant.kPrimary, width: 1.5),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              hintText: 'Search Therapist',
              hintStyle:
                  kStyle12.copyWith(fontSize: 12.0, color: Colors.grey[400]),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        SizedBox(
          width: 45,
          height: 45,
          child: GestureDetector(
            onTap: () {
              if (keyword != null) {
                setState(() {});
              }
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: ColorConstant.kPrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.search,
                color: ColorConstant.kWhite,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget searchTherapistList(context) {
    return StreamBuilder(
        stream: FirebaseQueryHelper.getCollectionsAsStream(
          collectionPath: "users",
        ),
        builder: (context, snapshot) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>>? therapist =
              snapshot.data?.docs
                  .where((element) => element.data()['isTherapist'] == true)
                  .toList();
          if (keyword != null) {
            matchingTherapist = findTherapistsByKeyword(therapist!, keyword!);
          } else {
            matchingTherapist = therapist;
          }
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : matchingTherapist == null || matchingTherapist.isEmpty
                  ? myEmptyCard(
                      context: context,
                      emptyMsg: 'No therapist',
                      subTitle: 'No any therapists are available')
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                              crossAxisCount: 2,
                              height: 200,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                      itemCount: matchingTherapist.length,
                      itemBuilder: (BuildContext ctx, index) {
                        final item = matchingTherapist[index].data();
                        return GestureDetector(
                          onTap: () {
                            pushTo(
                                context: context,
                                screen: TherapistDetailScreen(data: item));
                          },
                          child: Container(
                            width: maxWidth(context),
                            decoration: BoxDecoration(
                                color: ColorConstant.kWhite,
                                boxShadow: [
                                  BoxShadow(
                                      color: ColorConstant.kGrey,
                                      offset: const Offset(3, 3))
                                ],
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: myCachedNetworkImage(
                                    myWidth: maxWidth(context),
                                    myHeight: maxHeight(context),
                                    myImage: '',
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${item['username']}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: kStyle14B,
                                      ),
                                      myRatingBar(Random().nextInt(5) + 1,
                                          size: 12.0),
                                      sizedBox2(),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.email_outlined,
                                            size: 12.0,
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Flexible(
                                            child: Text(
                                              "${item['email']}",
                                              overflow: TextOverflow.ellipsis,
                                              style: kStyle12B.copyWith(
                                                color: ColorConstant.kBlue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // StreamBuilder(
                                      //     stream:
                                      //         therapistController.getAllBookings(
                                      //             uid: FirebaseAuth
                                      //                 .instance.currentUser!.uid,
                                      //             therapistID: id!),
                                      //     builder: (context, snapshot) {
                                      //       bool isBookedAlready =
                                      //           snapshot.data?.data() != null;
                                      //       return TextButton(
                                      //         onPressed: isBookedAlready
                                      //             ? () {}
                                      //             : () {
                                      //                 showDialog(
                                      //                   context: context,
                                      //                   builder: (context) {
                                      //                     return StatefulBuilder(
                                      //                         builder: (context,
                                      //                             setState) {
                                      //                       return AlertDialog(
                                      //                         title: const Text(
                                      //                             "Select date and time"),
                                      //                         content: Column(
                                      //                           crossAxisAlignment:
                                      //                               CrossAxisAlignment
                                      //                                   .start,
                                      //                           mainAxisSize:
                                      //                               MainAxisSize
                                      //                                   .min,
                                      //                           children: [
                                      //                             InkWell(
                                      //                               onTap:
                                      //                                   () async {
                                      //                                 selectedTime =
                                      //                                     null;
                                      //                                 setState(
                                      //                                     () {});
                                      //                                 final time = await showTimePicker(
                                      //                                     context:
                                      //                                         context,
                                      //                                     initialTime:
                                      //                                         TimeOfDay
                                      //                                             .now());
                                      //                                 selectedTime =
                                      //                                     time?.format(
                                      //                                         context);
                                      //                                 setState(
                                      //                                     () {});
                                      //                               },
                                      //                               child: Text(
                                      //                                   selectedTime ??
                                      //                                       "Select Time"),
                                      //                             ),
                                      //                             InkWell(
                                      //                               onTap:
                                      //                                   () async {
                                      //                                 selectedDate =
                                      //                                     null;
                                      //                                 final date = await showDatePicker(
                                      //                                     context:
                                      //                                         context,
                                      //                                     firstDate: DateTime
                                      //                                             .now()
                                      //                                         .subtract(const Duration(
                                      //                                             days:
                                      //                                                 1)),
                                      //                                     lastDate: DateTime
                                      //                                             .now()
                                      //                                         .add(const Duration(
                                      //                                             days: 2)));
                                      //                                 setState(() {
                                      //                                   selectedDate = DateFormat(
                                      //                                           "EEEE, MMM d")
                                      //                                       .format(
                                      //                                           date!);
                                      //                                 });
                                      //                               },
                                      //                               child: Text(
                                      //                                   selectedDate ??
                                      //                                       "Select Date"),
                                      //                             ),
                                      //                           ],
                                      //                         ),
                                      //                         actions: [
                                      //                           TextButton(
                                      //                             onPressed: () {
                                      //                               Navigator.pop(
                                      //                                   context);
                                      //                               selectedTime =
                                      //                                   null;
                                      //                               selectedDate =
                                      //                                   null;
                                      //                               setState(() {});
                                      //                             },
                                      //                             child: const Text(
                                      //                                 "Cancel"),
                                      //                           ),
                                      //                           TextButton(
                                      //                             onPressed:
                                      //                                 () async {
                                      //                               if (selectedDate !=
                                      //                                       null &&
                                      //                                   selectedTime !=
                                      //                                       null) {
                                      //                                 await therapistController
                                      //                                     .onTherapistBookingRequest(
                                      //                                         time:
                                      //                                             selectedTime!,
                                      //                                         date:
                                      //                                             selectedDate!,
                                      //                                         username: FirebaseAuth
                                      //                                             .instance
                                      //                                             .currentUser!
                                      //                                             .displayName!,
                                      //                                         uid: FirebaseAuth
                                      //                                             .instance
                                      //                                             .currentUser!
                                      //                                             .uid,
                                      //                                         therapistID:
                                      //                                             id)
                                      //                                     .then((value) =>
                                      //                                         Navigator.pop(
                                      //                                             context));
                                      //                               }
                                      //                             },
                                      //                             child: const Text(
                                      //                                 "Request"),
                                      //                           ),
                                      //                         ],
                                      //                       );
                                      //                     });
                                      //                   },
                                      //                 );
                                      //               },
                                      //         child: StreamBuilder(
                                      //             stream: therapistController
                                      //                 .getAllBookings(
                                      //                     uid: FirebaseAuth.instance
                                      //                         .currentUser!.uid,
                                      //                     therapistID: id),
                                      //             builder: (context, snapshot) {
                                      //               bool isBookedAlready =
                                      //                   snapshot.data?.data() !=
                                      //                       null;
                                      //               return isBookedAlready
                                      //                   ? Text("Booked",
                                      //                       style: kStyle18)
                                      //                   : const Text("Book");
                                      //             }),
                                      //       );
                                      //     }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
        });
  }
}
