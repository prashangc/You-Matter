import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/core/utils/text_form_field.dart';

editProfileBottomSheet({required context}) {
  String? username;
  GlobalKey<FormState> userNameFormKey = GlobalKey<FormState>();

  return showModalBottomSheet(
    context: context,
    backgroundColor: ColorConstant.backgroundColor,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    routeSettings: ModalRoute.of(context)!.settings,
    builder: ((builder) => Container(
          width: maxWidth(context),
          padding: EdgeInsets.only(
              top: 12.0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 12.0,
              right: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  "Edit Profile",
                  style: kStyle18B,
                ),
              ),
              sizedBox16(),
              myTextFormField(
                  context: context,
                  labelText: 'Username',
                  errorMessage: 'Please enter your username',
                  form: userNameFormKey,
                  onValueChanged: (v) {
                    username = v;
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
                    bool? isValid = userNameFormKey.currentState?.validate();
                    if (isValid == true) {
                      Navigator.pop(context, username);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Update',
                        style: kStyle12.copyWith(color: ColorConstant.kWhite)),
                  ),
                ),
              ),
            ],
          ),
        )),
  );
}
