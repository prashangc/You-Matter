import 'package:flutter/material.dart';
import 'package:you_matter/core/route/route.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/button.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/core/utils/text_form_field.dart';
import 'package:you_matter/features/register/presentation/ui/register.dart';
import 'package:you_matter/services/state/state_bloc.dart';

Widget loginForm(context, formKeys) {
  return Container(
    padding: const EdgeInsets.all(24.0),
    decoration: BoxDecoration(
      color: ColorConstant.kWhite.withOpacity(0.4),
      borderRadius: const BorderRadius.all(
        Radius.circular(24.0),
      ),
    ),
    child: Column(
      children: [
        myTextFormField(
          form: formKeys[0],
          context: context,
          labelText: 'enter name',
          errorMessage: 'errorMessage',
          title: 'Login',
          isEmail: true,
          onValueChanged: (v) {},
        ),
        myTextFormField(
          context: context,
          labelText: 'enter password',
          errorMessage: 'errorMessage',
          title: 'Password',
          onValueChanged: (v) {},
          visibilityIconBloc: StateHandlerBloc(),
          form: formKeys[1],
        ),
        myButton(
          context: context,
          width: maxWidth(context),
          height: 50.0,
          text: 'Login',
          bloc: StateHandlerBloc(),
          myTap: () {},
          validateKeys: formKeys,
        ),
        sizedBox12(),
        GestureDetector(
          onTap: () {
            pushTo(context: context, screen: const RegisterScreen());
          },
          child: SizedBox(
            width: maxWidth(context),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Don\'t have an account?',
                style: kStyle12,
                children: <TextSpan>[
                  TextSpan(
                    text: ' Sign Up',
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
