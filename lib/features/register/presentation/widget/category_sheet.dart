import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/utils/button.dart';
import 'package:you_matter/core/utils/my_toast.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';
import 'package:you_matter/services/state/state_bloc.dart';

Widget categoryBottomModelSheet(context) {
  StateHandlerBloc radioBtnStateBloc = StateHandlerBloc();
  StateHandlerBloc radioBtnValueStateBloc = StateHandlerBloc();
  return StatefulBuilder(
    builder: (ctx, setState) {
      return Container(
        width: maxWidth(context),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                width: maxWidth(context),
                decoration: BoxDecoration(
                  color: ColorConstant.kWhite,
                  boxShadow: [
                    BoxShadow(
                        color: ColorConstant.kGrey, offset: const Offset(3, 3))
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
                child: StreamBuilder(
                    stream: FirebaseQueryHelper.firebaseFireStore
                        .collection("categories")
                        .snapshots(),
                    builder: (context, snapshot) {
                      final categories = snapshot.data?.docs;
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: categories?.length,
                                    itemBuilder: (ctx, i) {
                                      final item =
                                          snapshot.data?.docs[i].data();
                                      return GestureDetector(
                                        onTap: () {},
                                        child: StreamBuilder<dynamic>(
                                            initialData: 0,
                                            stream:
                                                radioBtnStateBloc.stateStream,
                                            builder: (c, s) {
                                              return CheckboxListTile(
                                                contentPadding: EdgeInsets.zero,
                                                dense: true,
                                                title: Text(item?['name']),
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                                value: s.data == item?['id']
                                                    ? true
                                                    : false,
                                                onChanged: (value) {
                                                  radioBtnStateBloc.storeData(
                                                      data: item?['id']);
                                                  radioBtnValueStateBloc
                                                      .storeData(
                                                          data: item?['name']);
                                                },
                                              );
                                              // myRadioButton(
                                              //   index: s.data,
                                              //   onChanged: (v) {},
                                              //   title: item?['name'],
                                              // );
                                            }),
                                      );
                                    }),
                                sizedBox8(),
                                StreamBuilder<dynamic>(
                                    initialData: null,
                                    stream: radioBtnValueStateBloc.stateStream,
                                    builder: (c, s) {
                                      return myButton(
                                        context: context,
                                        width: 100,
                                        height: 40,
                                        text: 'Save',
                                        myTap: () {
                                          if (s.data == null) {
                                            myToast.toast(
                                                msg:
                                                    'Select atleast one category',
                                                context: context);
                                          } else {
                                            Navigator.pop(context, s.data);
                                          }
                                        },
                                      );
                                    }),
                              ],
                            );
                    }),
              ),
            ],
          ),
        ),
      );
    },
  );
}
