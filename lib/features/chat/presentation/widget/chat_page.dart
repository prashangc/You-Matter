import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/core/utils/time_utils.dart';
import 'package:you_matter/features/chat/presentation/widget/chat_textformfield.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';

Widget chatPage(context, Map<String, dynamic>? chatWith,
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
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                            ? MessagesWidget(listOfMessages: listOfMessages)
                            : const Center(
                                child: Text("No chats available"),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isBetween) ...{
            chatTextForm(context, chatWith, textEditingController)
          },
        ],
      ),
    ),
  );
}

class MessagesWidget extends StatelessWidget {
  const MessagesWidget({
    super.key,
    required this.listOfMessages,
  });

  final List listOfMessages;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      reverse: true,
      children: listOfMessages.reversed.map(
        (e) {
          bool isMyMessage =
              e['senderID'] == FirebaseAuth.instance.currentUser?.uid;
          return Align(
            alignment:
                isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              decoration: BoxDecoration(
                color: isMyMessage ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${e['content']}",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
