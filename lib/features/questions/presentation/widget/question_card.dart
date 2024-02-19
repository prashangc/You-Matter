import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/questions/presentation/widget/my_chat_list_view.dart';
import 'package:you_matter/services/state/state_bloc.dart';

Widget questionCard(context, StateHandlerBloc chatStateBloc) {
  return Column(
    children: [
      sizedBox16(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text.rich(
            TextSpan(
              text: 'I\'m your\n',
              style: kStyle18B,
              children: <InlineSpan>[
                TextSpan(
                  text: 'Digital Assistance',
                  style: kStyle12B.copyWith(
                    fontSize: 22.0,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              chatStateBloc.storeData(data: 0);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: ColorConstant.kBlack,
                shape: BoxShape.circle,
              ),
              child: Icon(
                FontAwesomeIcons.xmark,
                color: ColorConstant.kWhite,
                size: 14.0,
              ),
            ),
          ),
        ],
      ),
      sizedBox24(),
      Expanded(
        child: myChatListView(context),
      ),
    ],
  );
}
