import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/my_bloc_builder.dart';
import 'package:you_matter/core/utils/my_cached_network_image.dart';
import 'package:you_matter/core/utils/sizes.dart';

Widget categoryCard(context, categoryBloc) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: kStyle14B,
        ),
        sizedBox16(),
        myBlocBuilder(
          mainGetBloc: categoryBloc,
          endpoint: 'CATEGORY',
          subtitle: '',
          emptyMsg: 'No any categories',
          card: (resp) {
            return SizedBox(
              height: 40.0,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                itemCount: 0,
                itemBuilder: (c, i) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.all(12.0),
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
                    child: Row(
                      children: [
                        myCachedNetworkImage(
                          myWidth: 30.0,
                          myHeight: 30.0,
                          myImage: '',
                          borderRadius:
                              const BorderRadius.all(Radius.circular(0)),
                        ),
                        sizedBox8(),
                        Text(
                          'N/A',
                          style: kStyle12B,
                        ),
                        sizedBox12(),
                      ],
                    ),
                  );
                },
              ),
            );
          },
          context: context,
        ),
      ],
    ),
  );
}
