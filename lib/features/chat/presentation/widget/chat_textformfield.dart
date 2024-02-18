import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/features/request/controller/request_controller.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';

class ChatTextForm extends StatefulWidget {
  final Map<String, dynamic>? chatWith;
  const ChatTextForm({super.key, this.chatWith});

  @override
  State<ChatTextForm> createState() => _ChatTextFormState();
}

class _ChatTextFormState extends State<ChatTextForm> {
  final textEditingController = TextEditingController();

  Timer? _checkTypingTimer;
  startTimer() {
    _checkTypingTimer = Timer(const Duration(milliseconds: 600), () async {
      await FirebaseQueryHelper.firebaseFireStore
          .collection('typing')
          .doc("${widget.chatWith?['id']}")
          .update({
        'isTyping': false,
        'senderID': FirebaseAuth.instance.currentUser?.uid
      });
    });
  }

  resetTimer() {
    _checkTypingTimer?.cancel();
    startTimer();
  }

  @override
  void dispose() {
    _checkTypingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      focusNode: FocusNode(),
      cursorColor: ColorConstant.kPrimary,
      style: kStyle12,
      onChanged: (String value) async {
        resetTimer();
        final test = await FirebaseQueryHelper.firebaseFireStore
            .collection('typing')
            .doc("${widget.chatWith?['id']}")
            .get();
        if (test.exists) {
          await FirebaseQueryHelper.firebaseFireStore
              .collection('typing')
              .doc("${widget.chatWith?['id']}")
              .update({
            'isTyping': true,
            'senderID': FirebaseAuth.instance.currentUser?.uid
          });
        } else {
          await FirebaseQueryHelper.firebaseFireStore
              .collection('typing')
              .doc("${widget.chatWith?['id']}")
              .set({
            'chatID': "${widget.chatWith?['id']}",
            'isTyping': true,
            'senderID': FirebaseAuth.instance.currentUser?.uid
          });
        }
      },
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: () {},
          child: Container(
              decoration: BoxDecoration(
                color: ColorConstant.kPrimary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(26.0),
                  bottomRight: Radius.circular(26.0),
                ),
              ),
              child: true == true
                  ? InkWell(
                      onTap: () {
                        if (textEditingController.text.isNotEmpty) {
                          FocusScope.of(context).unfocus();
                          requestController.sendMessage(
                              chatID: widget.chatWith?['id'],
                              senderID:
                                  FirebaseAuth.instance.currentUser?.uid ?? "-",
                              content: textEditingController.text);

                          textEditingController.clear();
                        }
                      },
                      child: Icon(
                        Icons.arrow_upward_rounded,
                        size: 24,
                        color: ColorConstant.kWhite,
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.all(15.0),
                      width: 15.0,
                      height: 15.0,
                      child: CircularProgressIndicator(
                        color: ColorConstant.kWhite,
                        backgroundColor: ColorConstant.kGreen,
                        strokeWidth: 1.0,
                      ),
                    )),
        ),
        errorMaxLines: 2,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        filled: true,
        fillColor: ColorConstant.backgroundColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(26.0),
          ),
          borderSide: BorderSide(color: ColorConstant.kTransparent, width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(26.0),
          ),
          borderSide: BorderSide(color: ColorConstant.kPrimary, width: 1.5),
        ),
        errorStyle: kStyle12.copyWith(color: ColorConstant.kRed),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(26.0),
          ),
          borderSide: BorderSide(color: ColorConstant.kBlack, width: 1.5),
        ),
        hintText: 'Talk about your problem...',
        hintStyle: kStyle12,
      ),
    );
  }
}
