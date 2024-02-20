import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/chat_loading.dart';
import 'package:you_matter/core/utils/my_cached_network_image.dart';
import 'package:you_matter/core/utils/my_empty_card.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/core/utils/time_utils.dart';
import 'package:you_matter/features/chat/presentation/widget/chat_textformfield.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';

Widget chatPage(context, Map<String, dynamic>? chatWith, photo,
    TextEditingController textEditingController) {
  String? startTime = chatWith?['startTime'];
  String? endTime = chatWith?['endTime'];
  bool isBetween = isTimeInRange(startTime, endTime);

  return Expanded(
    child: Container(
      width: maxWidth(context),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: ColorConstant.kWhite,
        boxShadow: [
          BoxShadow(color: ColorConstant.kGrey, offset: const Offset(3, 3))
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SizedBox(
              width: maxWidth(context),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    sizedBox8(),
                    StreamBuilder(
                      stream: FirebaseQueryHelper.firebaseFireStore
                          .collection('chatMessages')
                          .doc(chatWith?['id'])
                          .snapshots(),
                      builder: (context, snapshot) {
                        final listOfMessages = snapshot.data
                            ?.data()?['messages'] as List<dynamic>?;
                        return listOfMessages != null &&
                                listOfMessages.isNotEmpty
                            ? MessagesWidget(
                                chatWith: chatWith!,
                                listOfMessages: listOfMessages,
                                photo: photo)
                            : myEmptyCard(
                                context: context,
                                emptyMsg: 'No any chats available',
                                subTitle: '');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isBetween) ...{ChatTextForm(chatWith: chatWith)},
        ],
      ),
    ),
  );
}

class MessagesWidget extends StatelessWidget {
  const MessagesWidget({
    super.key,
    required this.listOfMessages,
    required this.photo,
    required this.chatWith,
  });

  final List listOfMessages;
  final String photo;
  final Map<String, dynamic> chatWith;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          reverse: true,
          children: listOfMessages.reversed.map(
            (e) {
              bool isMyMessage =
                  e['senderID'] == FirebaseAuth.instance.currentUser?.uid;
              return Row(
                mainAxisAlignment: isMyMessage
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (!isMyMessage) ...{
                    Container(
                      width: 45.0,
                      height: 45.0,
                      decoration: BoxDecoration(
                        color: ColorConstant.kGrey,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: myCachedNetworkImageCircle(
                          myWidth: 45.0,
                          myHeight: 45.0,
                          myImage: photo,
                        ),
                      ),
                    ),
                    sizedBox12(),
                  },
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 14.0),
                      margin: EdgeInsets.only(
                        bottom: 10,
                        right: isMyMessage ? 0 : 100,
                        left: isMyMessage ? 100 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: isMyMessage
                            ? ColorConstant.kBlue
                            : ColorConstant.kGrey,
                        borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(12.0),
                          topRight: const Radius.circular(12.0),
                          topLeft: Radius.circular(isMyMessage ? 12 : 0.0),
                          bottomRight: Radius.circular(isMyMessage ? 0 : 12.0),
                        ),
                      ),
                      child: Text("${e['content']}",
                          overflow: TextOverflow.clip,
                          style: kStyle12.copyWith(
                            color: isMyMessage
                                ? ColorConstant.kWhite
                                : ColorConstant.kBlack,
                          )),
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
        StreamBuilder(
            stream: FirebaseQueryHelper.firebaseFireStore
                .collection('typing')
                .doc("${chatWith['id']}")
                .snapshots(),
            builder: (context, snapshot) {
              bool isTyping = snapshot.data?.data()?['isTyping'] == true;
              bool isSender = snapshot.data?.data()?['senderID'] !=
                  FirebaseAuth.instance.currentUser?.uid;
              bool isOurChat =
                  chatWith['id'] == snapshot.data?.data()?['chatID'];
              return isTyping && isSender && isOurChat
                  ? Row(
                      children: [
                        Container(
                          width: 45.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                            color: ColorConstant.kGrey,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: myCachedNetworkImageCircle(
                              myWidth: 45.0,
                              myHeight: 45.0,
                              myImage: photo,
                            ),
                          ),
                        ),
                        sizedBox12(),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 14.0),
                            decoration: BoxDecoration(
                              color: ColorConstant.kGrey,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12.0),
                                topRight: Radius.circular(12.0),
                                bottomRight: Radius.circular(12.0),
                              ),
                            ),
                            child: const ChatLoading()),
                      ],
                    )
                  : const SizedBox.shrink();
            }),
      ],
    );
  }
}
