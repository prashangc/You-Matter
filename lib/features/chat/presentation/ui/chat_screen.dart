import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/chat/presentation/widget/chat_app_bar.dart';
import 'package:you_matter/features/chat/presentation/widget/chat_page.dart';
import 'package:you_matter/features/chat/presentation/widget/therapist_details.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  void _sendMessage() {
    String messageText = _textEditingController.text.trim();
    if (messageText.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'text': messageText,
        'createdAt': Timestamp.now(),
        // Add other fields like senderId, senderName, etc. if needed
      });
      _textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ColorConstant.kPrimary,
        automaticallyImplyLeading: false,
        toolbarHeight: 0.0,
      ),
      backgroundColor: ColorConstant.backgroundColor,
      body: SizedBox(
        width: maxWidth(context),
        height: maxHeight(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            chatAppBar(),
            Expanded(
              child: Stack(
                children: [
                  Column(
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
                      Expanded(
                        child: Container(
                          width: maxWidth(context),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 25.0,
                    bottom: 25.0,
                    left: 20.0,
                    right: 20.0,
                    child: Column(
                      children: [
                        therapistDetails(context),
                        sizedBox16(),
                        chatPage(context),
                      ],
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
