import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';

class AddTimeScreen extends StatefulWidget {
  final Map<String, dynamic>? data;
  const AddTimeScreen({super.key, this.data});

  @override
  State<AddTimeScreen> createState() => _AddTimeScreenState();
}

class _AddTimeScreenState extends State<AddTimeScreen> {
  String? startTime;
  String? endTime;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
          return Scaffold(
            appBar: AppBar(
              title: const Text("Times"),
            ),
            body: snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : filteredTime != null && filteredTime.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredTime.length,
                        itemBuilder: (context, index) {
                          final time = filteredTime[index];
                          return ListTile(
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
                                            'startTime': e['startTime'],
                                            'endTime': e['endTime'],
                                            'createdOn': e['createdOn']
                                          })
                                      .toList();
                                }
                                previous.removeAt(index);
                                FirebaseQueryHelper.firebaseFireStore
                                    .collection('time')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .set({'times': previous});
                              },
                              icon: const Icon(
                                Icons.delete,
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text("No Times"),
                      ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                setState(() {
                  startTime = null;
                  endTime = null;
                });
                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () async {
                                  final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now());
                                  startTime = time?.format(context).toString();
                                  setState(() {});
                                },
                                child: Text(startTime ?? "Select start time"),
                              ),
                              InkWell(
                                onTap: () async {
                                  final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now());
                                  endTime = time?.format(context).toString();
                                  setState(() {});
                                },
                                child: Text(endTime ?? "Select end time"),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (startTime != null && endTime != null) {
                                  List<dynamic> previous = [];
                                  if (filteredTime != null &&
                                      filteredTime.isNotEmpty) {
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
                                    'startTime': startTime,
                                    'endTime': endTime,
                                    'createdOn': DateFormat("EEEE, MMM d")
                                        .format(DateTime.now()),
                                  });
                                  FirebaseQueryHelper.firebaseFireStore
                                      .collection('time')
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .set({'times': previous});
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text("Add"),
                            ),
                          ],
                        );
                      });
                    });
              },
            ),
          );
        });
  }
}
