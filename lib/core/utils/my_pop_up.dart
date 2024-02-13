import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/services/global_bloc/post_bloc/main_bloc.dart';
import 'package:you_matter/services/global_bloc/post_bloc/main_bloc_state.dart';

class PopUpHelper {
  loadingAlert({required context, required myTap}) {
    return showDialog(
        context: context,
        routeSettings: ModalRoute.of(context)!.settings,
        builder: (c) {
          return BlocBuilder<MainPostBloc, MainPostState>(
              bloc: BlocProvider.of(context),
              builder: (c, state) {
                return AlertDialog(
                  backgroundColor: ColorConstant.kTransparent,
                  insetPadding: const EdgeInsets.all(10),
                  contentPadding: EdgeInsets.zero,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    color: ColorConstant.kTransparent,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 50),
                            padding: const EdgeInsets.only(top: 60),
                            decoration: BoxDecoration(
                                color: ColorConstant.backgroundColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                sizedBox12(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                      state is LoadingState
                                          ? state.msg.toString()
                                          : state is SuccessState
                                              ? state.msg.toString()
                                              : state is ErrorState
                                                  ? state.msg.toString()
                                                  : state is ConfirmationState
                                                      ? state.msg.toString()
                                                      : 'something_went_wrong',
                                      style: kStyle14B,
                                      textAlign: TextAlign.center),
                                ),
                                sizedBox12(),
                                state is ErrorState
                                    ? ListView.builder(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: maxWidth(context) / 8),
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: state.listOfErrors.length,
                                        itemBuilder: (ctx, i) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 2.0),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 10.0,
                                                  backgroundColor:
                                                      ColorConstant.kWhite,
                                                  child: Text(
                                                    (i + 1).toString(),
                                                    style: kStyle12.copyWith(
                                                      fontSize: 10.0,
                                                      color: ColorConstant.kRed,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10.0),
                                                Expanded(
                                                  child: Text(
                                                    state.listOfErrors[i]
                                                        .toString(),
                                                    style: kStyle12.copyWith(
                                                        color:
                                                            ColorConstant.kRed),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : Container(),
                                state is ErrorState
                                    ? sizedBox12()
                                    : Container(),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: maxWidth(context) / 4),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: state is LoadingState
                                          ? ColorConstant.kTransparent
                                          : state is ErrorState
                                              ? ColorConstant.kRed
                                              : ColorConstant.kPrimary,
                                      elevation: 0.0,
                                      padding: const EdgeInsets.all(8.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                          color: ColorConstant.kTransparent,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (state is LoadingState) {
                                      } else if (state is ErrorState) {
                                        Navigator.pop(c);
                                      } else if (state is ConfirmationState) {
                                        state.func!();
                                      } else {
                                        Navigator.pop(c);
                                        myTap();
                                      }
                                    },
                                    child: state is LoadingState
                                        ? Container()
                                        : Text(
                                            'ok',
                                            style: kStyle12.copyWith(
                                                color: ColorConstant.kWhite),
                                          ),
                                  ),
                                ),
                                sizedBox12(),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 100.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  color: ColorConstant.backgroundColor,
                                  border: Border.all(
                                      color: ColorConstant.backgroundColor,
                                      width: 2),
                                  shape: BoxShape.circle,
                                ),
                                child: state is LoadingState
                                    ? Padding(
                                        padding: const EdgeInsets.all(32.0),
                                        child: CircularProgressIndicator(
                                          color: ColorConstant.kPrimary,
                                          backgroundColor: ColorConstant.kWhite,
                                        ),
                                      )
                                    : Icon(
                                        state is SuccessState
                                            ? Icons.check_circle_outline
                                            : state is ErrorState
                                                ? Icons.error_outline_outlined
                                                : state is ConfirmationState
                                                    ? Icons
                                                        .error_outline_outlined
                                                    : Icons
                                                        .error_outline_outlined,
                                        color: state is ErrorState
                                            ? ColorConstant.kRed
                                            : ColorConstant.kPrimary,
                                        size: 60.0,
                                      ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  popUp(
      {required BuildContext context,
      required String message,
      required String type}) {
    return showDialog(
        context: context,
        routeSettings: ModalRoute.of(context)!.settings,
        builder: (c) {
          return AlertDialog(
            backgroundColor: ColorConstant.kTransparent,
            insetPadding: const EdgeInsets.all(10),
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width,
              color: ColorConstant.kTransparent,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 50),
                      padding: const EdgeInsets.only(top: 60),
                      decoration: BoxDecoration(
                          color: ColorConstant.backgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          sizedBox12(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(message,
                                style: kStyle14B, textAlign: TextAlign.center),
                          ),
                          sizedBox12(),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: maxWidth(context) / 4),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: type == 'success'
                                    ? ColorConstant.kPrimary
                                    : ColorConstant.kRed,
                                elevation: 0.0,
                                padding: const EdgeInsets.all(8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: ColorConstant.kTransparent,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(c);
                              },
                              child: Text(
                                'ok',
                                style: kStyle12.copyWith(
                                    color: ColorConstant.kWhite),
                              ),
                            ),
                          ),
                          sizedBox12(),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                            color: ColorConstant.backgroundColor,
                            border: Border.all(
                                color: ColorConstant.backgroundColor, width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            type == 'success'
                                ? Icons.check_circle_outline
                                : Icons.error_outline_outlined,
                            color: type == 'success'
                                ? ColorConstant.kPrimary
                                : ColorConstant.kRed,
                            size: 60.0,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

PopUpHelper popUpHelper = PopUpHelper();
