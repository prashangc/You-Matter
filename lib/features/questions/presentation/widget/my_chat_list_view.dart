import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/chat_loading.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/questions/presentation/widget/filtered_therapist.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';
import 'package:you_matter/services/state/state_bloc.dart';

Widget myChatListView(context) {
  List<String> listOfUserMsg = [];
  List<String> listOfCategory = [];
  StateHandlerBloc questionListLengthBloc = StateHandlerBloc();
  StateHandlerBloc showLoadingBloc = StateHandlerBloc();
  return StreamBuilder(
      stream: FirebaseQueryHelper.getCollectionsAsStream(
          collectionPath: "questions"),
      builder: (context, snapshot) {
        final questionsList = snapshot.data?.docs;
        return snapshot.connectionState == ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : StreamBuilder<dynamic>(
                initialData: 1,
                stream: questionListLengthBloc.stateStream,
                builder: (cc, ss) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ss.data,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext ctx, index) {
                              Map<String, dynamic>? item;
                              String? question;
                              List? answersList;
                              if (ss.data <= questionsList?.length) {
                                item = snapshot.data?.docs[index].data();
                                question = item?['question'];
                                answersList = item?['answers'];
                              } else {
                                question =
                                    'Here are the results based on your answers';
                                answersList = [];
                              }
                              Future.delayed(const Duration(seconds: 1), () {
                                showLoadingBloc.storeData(data: false);
                              });
                              return Container(
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  child: Column(
                                    children: [
                                      // botChatCard(
                                      //   context,
                                      //   index,
                                      //   item,
                                      //   index == (ss.data - 1) ? true : false,
                                      //   questionsList?.length,
                                      //   questionListLengthBloc,
                                      //   listOfUserMsg,
                                      // ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 45.0,
                                                height: 45.0,
                                                decoration: BoxDecoration(
                                                  color: ColorConstant.kGrey,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Image.asset(
                                                    'assets/images/logo.png',
                                                    width: 45.0,
                                                    height: 45.0,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12.0),
                                              // loading
                                              // Container(
                                              //           padding: const EdgeInsets.symmetric(
                                              //               horizontal: 12.0, vertical: 14.0),
                                              //           decoration: BoxDecoration(
                                              //             color: kWhite.withOpacity(0.4),
                                              //             borderRadius: const BorderRadius.only(
                                              //               bottomLeft: Radius.circular(12.0),
                                              //               topRight: Radius.circular(12.0),
                                              //               bottomRight: Radius.circular(12.0),
                                              //             ),
                                              //           ),
                                              //           alignment: Alignment.centerLeft,
                                              //           child: const ChatLoading())
                                              // :
                                              StreamBuilder<dynamic>(
                                                  initialData: true,
                                                  stream: showLoadingBloc
                                                      .stateStream,
                                                  builder: (showLoadingContext,
                                                      showLoadingSnapshot) {
                                                    return Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12.0,
                                                                    vertical:
                                                                        14.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  ColorConstant
                                                                      .kGrey,
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        12.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        12.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        12.0),
                                                              ),
                                                            ),
                                                            child: showLoadingSnapshot
                                                                        .data ==
                                                                    true
                                                                ? const ChatLoading()
                                                                : Text(
                                                                    question!,
                                                                    style: kStyle12
                                                                        .copyWith(
                                                                            color:
                                                                                ColorConstant.kBlack),
                                                                  ),
                                                          ),
                                                          sizedBox8(),
                                                          showLoadingSnapshot
                                                                      .data ==
                                                                  true
                                                              ? Container()
                                                              : index ==
                                                                      (ss.data -
                                                                          1)
                                                                  ? answersList!
                                                                          .isEmpty
                                                                      ? FilteredTherapist(
                                                                          categoryList:
                                                                              listOfCategory)
                                                                      : ListView.builder(
                                                                          itemCount: answersList.length,
                                                                          shrinkWrap: true,
                                                                          physics: const NeverScrollableScrollPhysics(),
                                                                          itemBuilder: (ctx, i) {
                                                                            return GestureDetector(
                                                                              onTap: () {
                                                                                questionListLengthBloc.storeData(data: ss.data + 1);
                                                                                listOfUserMsg.add(answersList![i]['answer']);
                                                                                listOfCategory.add(answersList[i]['category']);
                                                                              },
                                                                              child: Container(
                                                                                  margin: const EdgeInsets.only(bottom: 8),
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                                                                                  decoration: BoxDecoration(
                                                                                    color: ColorConstant.kGrey,
                                                                                    borderRadius: const BorderRadius.only(
                                                                                      bottomLeft: Radius.circular(12.0),
                                                                                      topRight: Radius.circular(12.0),
                                                                                      bottomRight: Radius.circular(12.0),
                                                                                    ),
                                                                                  ),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Flexible(
                                                                                          child: Text(
                                                                                        answersList![i]['answer'],
                                                                                        style: kStyle12,
                                                                                        textAlign: TextAlign.justify,
                                                                                      )),
                                                                                      sizedBox24(),
                                                                                      Icon(
                                                                                        Icons.circle_outlined,
                                                                                        color: ColorConstant.kPrimary,
                                                                                        size: 16.0,
                                                                                      )
                                                                                    ],
                                                                                  )),
                                                                            );
                                                                          })
                                                                  : Container()
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                              const SizedBox(width: 12.0),
                                            ],
                                          ),
                                        ],
                                      ),
                                      index > listOfUserMsg.length - 1
                                          ? Container()
                                          : SizedBox(
                                              width: maxWidth(context),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    const SizedBox(
                                                        width: 45.0,
                                                        height: 45.0),
                                                    const SizedBox(width: 12.0),
                                                    Flexible(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    12.0,
                                                                vertical: 14.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: ColorConstant
                                                              .kBlue,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    12.0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    12.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    12.0),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          listOfUserMsg[index],
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style:
                                                              kStyle12.copyWith(
                                                            color: ColorConstant
                                                                .kWhite,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12.0),
                                                    // Guest
                                                    // Container(
                                                    //           width: 45.0,
                                                    //           height: 45.0,
                                                    //           decoration: BoxDecoration(
                                                    //             color: ColorConstant.kWhite.withOpacity(0.4),
                                                    //             shape: BoxShape.circle,
                                                    //           ),
                                                    //           child: Center(
                                                    //             child: Text(
                                                    //               profileModel!.member!.name!
                                                    //                   .substring(0, 1)
                                                    //                   .capitalize(),
                                                    //               style: kStyleNormal.copyWith(
                                                    //                 color: myColor.primaryColorDark,
                                                    //                 fontSize: 16.0,
                                                    //                 fontWeight: FontWeight.bold,
                                                    //               ),
                                                    //             ),
                                                    //           ),
                                                    //         )
                                                    Image.asset(
                                                      'assets/images/profile.png',
                                                      width: 45.0,
                                                      height: 45.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ],
                                  ));
                            }),
                        // ListView.builder(
                        //     physics: const NeverScrollableScrollPhysics(),
                        //     shrinkWrap: true,
                        //     itemCount: listOfCategory.length,
                        //     itemBuilder: (categoryContext, categoryIndex) {
                        //       return Text(listOfCategory[categoryIndex]);
                        //     })
                      ],
                    ),
                  );
                });
      });
}
