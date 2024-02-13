import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/services/state/state_bloc.dart';

Widget myTextFormField({
  required BuildContext context,
  required String labelText,
  required String errorMessage,
  ValueChanged<String>? onValueChanged,
  String? title,
  bool? isNumber,
  bool? isEmail,
  bool? isTextArea,
  StateHandlerBloc? visibilityIconBloc,
  required form,
  IconData? prefixIcon,
  List<String>? passwordList,
  bool? readOnly,
}) {
  StateHandlerBloc errorColorBloc = StateHandlerBloc();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title == null
          ? Container()
          : Text(
              title,
              style: kStyle14B,
            ),
      title == null ? Container() : sizedBox16(),
      Form(
        key: form,
        child: StreamBuilder<dynamic>(
            initialData: visibilityIconBloc != null ? true : false,
            stream: visibilityIconBloc?.stateStream,
            builder: (pwContext, pwSnapshot) {
              return StreamBuilder<dynamic>(
                  initialData: false,
                  stream: errorColorBloc.stateStream,
                  builder: (context, errorColorSnapshot) {
                    return TextFormField(
                      maxLines: isTextArea != null ? 5 : 1,
                      readOnly: readOnly ?? false,
                      obscureText: pwSnapshot.data,
                      cursorColor: ColorConstant.kBlack,
                      style: kStyle12,
                      keyboardType:
                          isNumber == true ? TextInputType.number : null,
                      onChanged: (String value) {
                        if (value.isEmpty) {
                          errorColorBloc.storeData(data: true);
                        } else {
                          errorColorBloc.storeData(data: false);
                        }
                        onValueChanged!(value);
                        form.currentState?.validate();
                      },
                      decoration: InputDecoration(
                        prefixIcon: prefixIcon == null
                            ? null
                            : Icon(
                                prefixIcon,
                                size: 16,
                                color: ColorConstant.kBlack,
                              ),
                        suffixIcon: visibilityIconBloc == null
                            ? null
                            : GestureDetector(
                                onTap: () {
                                  visibilityIconBloc.storeData(
                                      data: !pwSnapshot.data!);
                                },
                                child: Icon(
                                  pwSnapshot.data == false
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 16,
                                  color: ColorConstant.kBlack,
                                ),
                              ),
                        errorMaxLines: 2,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 16.0),
                        filled: true,
                        fillColor: ColorConstant.kWhite.withOpacity(0.6),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(24.0),
                          ),
                          borderSide: BorderSide(
                              color: ColorConstant.kTransparent, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(24.0),
                          ),
                          borderSide: BorderSide(
                              color: ColorConstant.kPrimary, width: 1.5),
                        ),
                        errorStyle:
                            kStyle12.copyWith(color: ColorConstant.kRed),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(24.0),
                          ),
                          borderSide: BorderSide(
                              color: ColorConstant.kBlack, width: 1.5),
                        ),
                        hintText: labelText,
                        hintStyle: kStyle12.copyWith(
                            color: errorColorSnapshot.data == false
                                ? ColorConstant.kBlack
                                : ColorConstant.kRed),
                      ),
                      validator: (v) {
                        if (isEmail == true && v!.isNotEmpty) {
                          if (!RegExp(r'^[a-zA-Z0-9.@-]+$').hasMatch(v)) {
                            errorColorBloc.storeData(data: true);
                            return '* Sorry, only letters (a-z), numbers (0-9), and periods(.) are allowed.';
                          }
                        }
                        if (visibilityIconBloc != null &&
                            v!.isNotEmpty &&
                            title != 'Confirm Password') {
                          // if (pw != cpw && title == 'Confirm Password') {
                          //   errorColorBloc.storeData(data: true);
                          //   return 'Password doesn\'t match.';
                          // }
                          if (!RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[$@!#&]).{8,}$')
                              .hasMatch(v)) {
                            return '* Required: atleast one Uppercase and lowercase letters (A,z), numbers(0-9) and special characters(!, %, @, #, etc.)';
                          }
                        }
                        if (v!.isEmpty) {
                          errorColorBloc.storeData(data: true);
                          return errorMessage;
                        }

                        return null;
                      },
                    );
                  });
            }),
      ),
      sizedBox16(),
    ],
  );
}
