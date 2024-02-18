import 'package:flutter/material.dart';
import 'package:you_matter/core/route/route.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/my_cached_network_image.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/articles/presentation/ui/article_detail_screen.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';

Widget articleCard(context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Related Articles',
          style: kStyle14B,
        ),
        sizedBox16(),
        StreamBuilder(
            stream: FirebaseQueryHelper.getCollectionsAsStream(
                collectionPath: "articles"),
            builder: (context, snapshot) {
              final therapist = snapshot.data?.docs;
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: therapist?.length,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext ctx, index) {
                        final item = snapshot.data?.docs[index].data();
                        String? title = item?['title'];
                        String? desc = item?['desc'];
                        String? image = item?['image'];
                        return GestureDetector(
                          onTap: () {
                            pushTo(
                                context: context,
                                screen: ArticleDetailsPage(
                                  desc: desc!,
                                  image: image,
                                  title: title!,
                                ));
                          },
                          child: Container(
                            width: maxWidth(context),
                            height: 100.0,
                            margin: const EdgeInsets.only(bottom: 12.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: ColorConstant.kWhite,
                                boxShadow: [
                                  BoxShadow(
                                      color: ColorConstant.kGrey,
                                      offset: const Offset(3, 3))
                                ],
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                    margin: const EdgeInsets.only(right: 10.0),
                                    child: myCachedNetworkImage(
                                      myWidth: maxWidth(context),
                                      myHeight: maxHeight(context),
                                      myImage: image!,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            width: maxWidth(context),
                                            margin: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Text(
                                              title.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: kStyle14B.copyWith(
                                                fontSize: 14.0,
                                                letterSpacing: 0.2,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'You Matter',
                                                textAlign: TextAlign.justify,
                                                style: kStyle12B.copyWith(
                                                  color: ColorConstant.kBlue,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 12.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
            }),
      ],
    ),
  );
}
