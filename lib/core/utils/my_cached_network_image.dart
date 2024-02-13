import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';

Widget myCachedNetworkImage({
  required double myWidth,
  required double myHeight,
  required String myImage,
  required BorderRadiusGeometry borderRadius,
}) {
  return CachedNetworkImage(
      width: myWidth,
      height: myHeight,
      imageUrl: myImage,
      imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                alignment: FractionalOffset.topCenter,
              ),
            ),
          ),
      placeholder: (context, url) => Center(
              child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: CircularProgressIndicator(
              color: ColorConstant.kPrimary,
              strokeWidth: 1.5,
              backgroundColor: ColorConstant.kWhite,
            ),
          )),
      errorWidget: (context, url, error) => Image.asset(
            'assets/app/logo.png',
          ));
}

Widget myCachedNetworkImageCircle({
  required double myWidth,
  required double myHeight,
  required String myImage,
}) {
  return CachedNetworkImage(
    width: myWidth,
    height: myHeight,
    imageUrl: myImage,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorConstant.kWhite,
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
          alignment: FractionalOffset.topCenter,
        ),
      ),
    ),
    placeholder: (context, url) => Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircularProgressIndicator(
        color: ColorConstant.kPrimary,
        strokeWidth: 1.5,
        backgroundColor: ColorConstant.kWhite,
      ),
    )),
    errorWidget: (context, url, error) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorConstant.kWhite,
      ),
      child: Image.asset('assets/mobile/logo.png'),
    ),
  );
}
