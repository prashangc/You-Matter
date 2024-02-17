import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/my_time_picker.dart';
import 'package:you_matter/core/utils/sizes.dart';

timingBottomSheet(
    {required context, required String? startTime, required String? endTime}) {
  final startTimeFormKey = GlobalKey<FormState>();
  final endTimeFormKey = GlobalKey<FormState>();

  return showModalBottomSheet(
    context: context,
    backgroundColor: ColorConstant.backgroundColor,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    routeSettings: ModalRoute.of(context)!.settings,
    builder: ((builder) => Container(
          width: maxWidth(context),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  "Set Schedule",
                  style: kStyle18B,
                ),
              ),
              sizedBox16(),
              myTimePicker(context, startTimeFormKey, startTime, 'Start Time',
                  Colors.white, 'Select Start Time', onValueChanged: (v) {
                startTime = v;
              }),
              sizedBox16(),
              myTimePicker(context, endTimeFormKey, endTime, 'End Time',
                  Colors.white, 'Select End Time', onValueChanged: (v) {
                endTime = v;
              }),
              sizedBox16(),
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
                    bool? isValid = startTimeFormKey.currentState?.validate();
                    bool? isValid2 = endTimeFormKey.currentState?.validate();

                    if (isValid == true && isValid2 == true) {
                      Navigator.pop(context, [startTime, endTime]);
                    }
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
