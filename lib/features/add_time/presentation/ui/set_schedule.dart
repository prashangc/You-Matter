import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/add_time/presentation/widgets/add_time_menu_screen.dart';
import 'package:you_matter/features/add_time/presentation/widgets/timing_bottom_sheet.dart';
import 'package:you_matter/features/booking/presentation/widget/booking_app_bar.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';
import 'package:you_matter/services/state/state_bloc.dart';

class AddTimeScreen extends StatefulWidget {
  final Map<String, dynamic>? data;
  const AddTimeScreen({super.key, this.data});

  @override
  State<AddTimeScreen> createState() => _AddTimeScreenState();
}

class _AddTimeScreenState extends State<AddTimeScreen> {
  StateHandlerBloc lengthBloc = StateHandlerBloc();
  String? startTime;
  String? endTime;
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
            bookingAppBar(context, 'Schedule', 'Your Timings', lengthBloc),
            Expanded(
              flex: 1,
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
                        addTimeMenu(
                          context,
                          lengthBloc,
                          startTime,
                          endTime,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder(
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
            return FloatingActionButton.extended(
                backgroundColor: ColorConstant.kPrimary,
                label: Row(
                  children: [
                    Text(
                      'Add',
                      style: kStyle18.copyWith(color: ColorConstant.kWhite),
                    ),
                    sizedBox2(),
                    sizedBox2(),
                    Icon(Icons.add, color: ColorConstant.kWhite),
                  ],
                ),
                onPressed: () async {
                  List<String?>? data = await timingBottomSheet(
                    context: context,
                    startTime: startTime,
                    endTime: endTime,
                  );
                  if (data != null && data.isNotEmpty) {
                    print(data[0]);
                    print(data[1]);
                    List<dynamic> previous = [];
                    if (filteredTime != null && filteredTime.isNotEmpty) {
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
                    previous.add({
                      'isBooked': false,
                      'scheduleID': const Uuid().v4(),
                      'startTime': data[0],
                      'endTime': data[1],
                      'createdOn':
                          DateFormat("EEEE, MMM d").format(DateTime.now()),
                    });
                    FirebaseQueryHelper.firebaseFireStore
                        .collection('time')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .set({'times': previous});
                  }
                });
          }),
    );
  }
}
