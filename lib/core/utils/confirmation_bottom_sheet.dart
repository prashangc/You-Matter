import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';

confirmationBottomSheet(
    {required context, required String title, required String subTitle}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: ColorConstant.backgroundColor,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    routeSettings: ModalRoute.of(context)!.settings,
    builder: ((builder) => Container(
          width: maxWidth(context),
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              sizedBox12(),
              CircleAvatar(
                radius: 40.0,
                backgroundColor: ColorConstant.kWhite,
                child: Image.asset(
                  'assets/images/logo.png',
                ),
              ),
              sizedBox8(),
              Text(
                title,
                style: kStyle12B.copyWith(
                  fontSize: 16.0,
                ),
              ),
              sizedBox16(),
              Text(
                subTitle,
                textAlign: TextAlign.justify,
                style: kStyle12,
              ),
              sizedBox24(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: maxWidth(context) / 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.kPrimary,
                    elevation: 0.0,
                    padding: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                  ),
                  onPressed: () {
                    Navigator.pop(context, 1);
                  },
                  child: Text('Ok',
                      style: kStyle12.copyWith(color: ColorConstant.kWhite)),
                ),
              ),
            ],
          ),
        )),
  );
}
