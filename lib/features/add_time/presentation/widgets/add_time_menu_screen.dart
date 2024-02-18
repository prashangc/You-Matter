import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/utils/my_empty_card.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';
import 'package:you_matter/services/state/state_bloc.dart';

Widget addTimeMenu(
  context,
  StateHandlerBloc lengthBloc,
  String? startTime,
  String? endTime,
) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: ColorConstant.kWhite,
        boxShadow: [
          BoxShadow(color: ColorConstant.kGrey, offset: const Offset(3, 3))
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        physics: const BouncingScrollPhysics(),
        child: StreamBuilder(
            stream: FirebaseQueryHelper.firebaseFireStore
                .collection('time')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              final times = snapshot.data?.data()?['times'] as List<dynamic>?;
              final filteredTime = times?.where((element) {
                final item = element as Map<String, dynamic>;
                bool isToday = item['createdOn'] ==
                    DateFormat("EEEE, MMM d").format(DateTime.now());
                return isToday;
              }).toList();
              if (filteredTime != null) {
                lengthBloc.storeData(data: filteredTime.length);
              }
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : filteredTime != null && filteredTime.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredTime.length,
                          itemBuilder: (context, index) {
                            final time = filteredTime[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12.0),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
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
                              child: ListTile(
                                leading: const Icon(Icons.schedule_rounded),
                                title: Text(
                                  "${time['startTime']}-${time['endTime']}",
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    List<dynamic> previous = [];
                                    if (filteredTime.isNotEmpty) {
                                      previous = filteredTime
                                          .map((e) => {
                                                'isBooked': e['isBooked'],
                                                'scheduleID': e['scheduleID'],
                                                'startTime': e['startTime'],
                                                'endTime': e['endTime'],
                                                'createdOn': e['createdOn']
                                              })
                                          .toList();
                                    }
                                    previous.removeAt(index);
                                    FirebaseQueryHelper.firebaseFireStore
                                        .collection('time')
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.uid)
                                        .set({'times': previous});
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: ColorConstant.kRed,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : myEmptyCard(
                          context: context,
                          emptyMsg: 'No any time added.',
                          subTitle: '');
            }),
      ),
    ),
  );
}
