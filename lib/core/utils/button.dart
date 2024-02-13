import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/focus_remover.dart';
import 'package:you_matter/core/utils/loading.dart';
import 'package:you_matter/services/state/state_bloc.dart';

Widget myButton({
  required BuildContext context,
  required double width,
  required double height,
  required String text,
  bool? isBold,
  StateHandlerBloc? bloc,
  Color? color,
  required Function myTap,
  validateKeys,
}) {
  return GestureDetector(
    onTap: () {
      myFocusRemover(context);
      if (validateKeys != null) {
        bool? isFormValid;
        List<int> listOfInvalidIndex = [];
        listOfInvalidIndex.clear();
        for (int i = 0; i < validateKeys.length; i++) {
          isFormValid = validateKeys[i].currentState?.validate();

          if (isFormValid == false) {
            listOfInvalidIndex.add(i);
          }
        }
        if (listOfInvalidIndex.isEmpty) {
          myTap();
        }
      } else {
        myTap();
      }
    },
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: color ?? ColorConstant.kPrimary,
      ),
      alignment: Alignment.center,
      child: StreamBuilder<dynamic>(
          initialData: 0,
          stream: bloc?.stateStream,
          builder: (c, s) {
            return s.data == 1
                ? const AnimatedLoading()
                : Text(
                    text,
                    style: kStyle18B.copyWith(
                        color: ColorConstant.kWhite, letterSpacing: 1),
                  );
          }),
    ),
  );
}
