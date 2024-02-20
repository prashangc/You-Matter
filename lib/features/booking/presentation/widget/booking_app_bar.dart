import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/services/state/state_bloc.dart';

Widget bookingAppBar(
  context,
  String title,
  String title2,
  StateHandlerBloc? lengthBloc, {
  bool? isOnboarding,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    color: ColorConstant.kPrimary,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (isOnboarding != true) ...{
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
            ),
          ),
        },
        sizedBox24(),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizedBox16(),
                  Text(
                    title,
                    style: kStyle18B.copyWith(),
                  ),
                  Text(
                    title2,
                    style: kStyle18B.copyWith(
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
              if (lengthBloc != null) ...{
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: ColorConstant.kWhite.withOpacity(0.4),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0))),
                  child: StreamBuilder<dynamic>(
                      initialData: 0,
                      stream: lengthBloc.stateStream,
                      builder: (c, s) {
                        if (s.data == null) {
                          return Text(
                            'Total : ${s.data}',
                            style: kStyle12.copyWith(),
                          );
                        } else {
                          return Text(
                            'Total : ${s.data}',
                            style: kStyle12.copyWith(),
                          );
                        }
                      }),
                ),
              }
            ],
          ),
        )
      ],
    ),
  );
}
