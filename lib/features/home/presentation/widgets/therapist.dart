import 'package:flutter/material.dart';
import 'package:you_matter/features/home/presentation/widgets/therapist_list.dart';

Widget therapistCard(context, hotelBloc) {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'Find Therapist',
        //   style: kStyle14B,
        // ),
        // sizedBox16(),
        // myBlocBuilder(
        //   endpoint: 'HOTEL',
        //   subtitle: '',
        //   mainGetBloc: hotelBloc,
        //   emptyMsg: 'No any therapist found',
        //   card: (resp) {
        //     return GridView.builder(
        //         shrinkWrap: true,
        //         physics: const NeverScrollableScrollPhysics(),
        //         gridDelegate:
        //             const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
        //                 crossAxisCount: 2,
        //                 height: 200,
        //                 crossAxisSpacing: 10,
        //                 mainAxisSpacing: 10),
        //         itemCount: 0,
        //         itemBuilder: (BuildContext ctx, index) {
        //           return GestureDetector(
        //             onTap: () {},
        //             child: Container(
        //               width: maxWidth(context),
        //               decoration: BoxDecoration(
        //                   color: ColorConstant.kWhite,
        //                   boxShadow: [
        //                     BoxShadow(
        //                         color: ColorConstant.kGrey,
        //                         offset: const Offset(3, 3))
        //                   ],
        //                   borderRadius: BorderRadius.circular(15)),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Expanded(
        //                     child: myCachedNetworkImage(
        //                       myWidth: maxWidth(context),
        //                       myHeight: maxHeight(context),
        //                       myImage: '',
        //                       borderRadius: const BorderRadius.all(
        //                         Radius.circular(12.0),
        //                       ),
        //                     ),
        //                   ),
        //                   Container(
        //                     padding: const EdgeInsets.symmetric(
        //                         horizontal: 10.0, vertical: 5.0),
        //                     child: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         Text(
        //                           'N/A',
        //                           maxLines: 1,
        //                           overflow: TextOverflow.ellipsis,
        //                           style: kStyle14B,
        //                         ),
        //                         myRatingBar(3, size: 12.0),
        //                         sizedBox2(),
        //                         Row(
        //                           children: [
        //                             const Icon(
        //                               Icons.location_on,
        //                               size: 12.0,
        //                             ),
        //                             const SizedBox(
        //                               width: 5.0,
        //                             ),
        //                             Flexible(
        //                               child: Text(
        //                                 'N/A',
        //                                 overflow: TextOverflow.ellipsis,
        //                                 style: kStyle12B.copyWith(
        //                                   color: ColorConstant.kBlue,
        //                                 ),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           );
        //         });
        //   },
        //   context: context,
        // ),
        TherapistList()
      ],
    ),
  );
}
