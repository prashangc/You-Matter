import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/booking/presentation/widget/booking_app_bar.dart';
import 'package:you_matter/features/questions/presentation/widget/intro_card.dart';
import 'package:you_matter/features/questions/presentation/widget/question_card.dart';
import 'package:you_matter/services/state/state_bloc.dart';

class QuestionAnswerScreen extends StatelessWidget {
  final bool isOnboarding;
  const QuestionAnswerScreen({super.key, required this.isOnboarding});

  @override
  Widget build(BuildContext context) {
    StateHandlerBloc chatStateBloc = StateHandlerBloc();
    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ColorConstant.kPrimary,
        automaticallyImplyLeading: false,
        toolbarHeight: 0.0,
      ),
      body: SizedBox(
        width: maxWidth(context),
        height: maxHeight(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bookingAppBar(context, 'Find', 'Therapist', null,
                isOnboarding: isOnboarding),
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: ColorConstant.kPrimary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        )),
                    width: maxWidth(context),
                    height: 50.0,
                  ),
                  Positioned(
                    top: 25.0,
                    bottom: 25.0,
                    left: 20.0,
                    right: 20.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: ColorConstant.kWhite,
                        boxShadow: [
                          BoxShadow(
                              color: ColorConstant.kGrey,
                              offset: const Offset(3, 3))
                        ],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      child: StreamBuilder<dynamic>(
                          initialData: 0,
                          stream: chatStateBloc.stateStream,
                          builder: (c, s) {
                            return s.data == 0
                                ? introCard(context, chatStateBloc)
                                : questionCard(context, chatStateBloc);
                          }),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
