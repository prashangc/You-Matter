import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/my_cached_network_image.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/booking/presentation/widget/booking_app_bar.dart';

class ArticleDetailsPage extends StatelessWidget {
  final String desc;
  final String title;
  final String image;
  const ArticleDetailsPage(
      {super.key,
      required this.desc,
      required this.title,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ColorConstant.kPrimary,
        automaticallyImplyLeading: false,
        toolbarHeight: 0.0,
      ),
      body: SizedBox(
        width: maxWidth(context),
        height: maxHeight(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bookingAppBar(context, 'Article', 'More Details', null),
            Expanded(
              flex: 1,
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: ColorConstant.kWhite,
                        boxShadow: [
                          BoxShadow(
                              color: ColorConstant.kGrey,
                              offset: const Offset(3, 3))
                        ],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              myCachedNetworkImageCircle(
                                  myHeight: 40.0, myWidth: 40.0, myImage: ''),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: kStyle14B,
                                    ),
                                    const SizedBox(height: 2.0),
                                    Row(
                                      children: [
                                        Text(
                                          'Posted by :',
                                          style: kStyle12B.copyWith(
                                              color: ColorConstant.kBlue),
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          'You Matter',
                                          style: kStyle12B.copyWith(
                                              color: ColorConstant.kBlue),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          sizedBox12(),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  myCachedNetworkImage(
                                    myWidth: maxWidth(context),
                                    myHeight: maxHeight(context) / 4,
                                    myImage: image,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                  ),
                                  sizedBox12(),
                                  SizedBox(
                                    width: maxWidth(context),
                                    child: Text(
                                      desc,
                                      textAlign: TextAlign.justify,
                                      style: kStyle12,
                                    ),
                                  ),
                                  sizedBox12(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
