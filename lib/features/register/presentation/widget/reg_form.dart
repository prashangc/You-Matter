import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/button.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/core/utils/text_form_field.dart';
import 'package:you_matter/features/register/controller/reg_controller.dart';
import 'package:you_matter/features/register/model/register_model.dart';

Widget formCard(context, RegisterModel model, formKeys, bool isTherapist) {
  return Container(
    padding: const EdgeInsets.all(24.0),
    decoration: BoxDecoration(
      color: ColorConstant.kWhite.withOpacity(0.4),
      borderRadius: const BorderRadius.all(
        Radius.circular(24.0),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        myTextFormField(
          context: context,
          form: formKeys[0],
          labelText: 'enter email',
          errorMessage: 'errorMessage',
          title: 'Email',
          isEmail: true,
          onValueChanged: (v) {
            model.email = v;
          },
        ),
        myTextFormField(
          context: context,
          form: formKeys[1],
          labelText: 'enter name',
          errorMessage: 'errorMessage',
          title: 'Name',
          onValueChanged: (v) {
            model.name = v;
          },
        ),
        myTextFormField(
          context: context,
          form: formKeys[2],
          labelText: 'enter phone',
          errorMessage: 'errorMessage',
          title: 'Phone',
          onValueChanged: (v) {
            model.phone = v;
          },
        ),
        StreamBuilder<dynamic>(
            initialData: const ['', ''],
            stream: registerController.confirmPwValidationBloc.stateStream,
            builder: (c, s) {
              return myTextFormField(
                context: context,
                form: formKeys[3],
                labelText: 'enter password',
                errorMessage: 'errorMessage',
                title: 'Password',
                visibilityIconBloc: registerController.pwVisibilityBloc,
                onValueChanged: (v) {
                  registerController.confirmPwValidationBloc.storeData(
                    data: [
                      v,
                      s.data[1],
                    ],
                  );
                  model.password = v;
                },
                passwordList: [
                  s.data[0],
                  s.data[1],
                ],
              );
            }),
        StreamBuilder<dynamic>(
            initialData: const ['', ''],
            stream: registerController.confirmPwValidationBloc.stateStream,
            builder: (c, s) {
              return myTextFormField(
                context: context,
                labelText: 'confirm password',
                errorMessage: 'errorMessage',
                title: 'Confirm Password',
                onValueChanged: (v) async {
                  model.passwordConfirmation = v;
                  registerController.confirmPwValidationBloc.storeData(
                    data: [s.data[0], v],
                  );
                },
                visibilityIconBloc: registerController.confirmPwVisibilityBloc,
                passwordList: [
                  s.data[0],
                  s.data[1],
                ],
                form: formKeys[4],
              );
            }),
        myButton(
          context: context,
          width: maxWidth(context),
          height: 50.0,
          text: 'Register',
          myTap: () {
            registerController.onBtnCick(context, model, isTherapist);
          },
          validateKeys: formKeys,
        ),
        sizedBox12(),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: SizedBox(
            width: maxWidth(context),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Already have an account?',
                style: kStyle12,
                children: <TextSpan>[
                  TextSpan(
                    text: ' Login',
                    style: kStyle14B,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
