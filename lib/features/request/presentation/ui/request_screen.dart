import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';
import 'package:collection/collection.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Request"),
      ),
      body: StreamBuilder(
        stream: FirebaseQueryHelper.firebaseFireStore
            .collection('bookings')
            .snapshots(),
        builder: (context, snapshot) {
          final bookings = snapshot.data?.docs
              .where((element) =>
                  element.id.split(":").first ==
                  FirebaseAuth.instance.currentUser!.uid)
              .toList();

          return bookings != null && bookings.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return sizedBox12();
                  },
                  itemCount: bookings.length ?? 0,
                  itemBuilder: (context, index) {
                    final booking = bookings[index].data();
                    final requestedOn = booking['requestedOn'] as Timestamp;
                    final patientID = booking['patientId'] as String;
                    final status = booking['status'] as String;
                    bool isRejected = status == "rejected";
                    bool isAccepted = status == "accepted";
                    bool isPending = status == "pending";
                    String? scheduleID = booking["scheduleID"];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.black,
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isPending) ...{
                                Text(
                                  status,
                                  style: TextStyle(
                                    color: isRejected
                                        ? Colors.red
                                        : isAccepted
                                            ? Colors.green
                                            : null,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              },
                              Text(
                                  "Patient Name: ${booking['patient']['username']}"),
                              Text(
                                  "Time: ${booking['startTime']} - ${booking['endTime']}")
                            ],
                          ),
                          if (!isRejected && !isAccepted) ...{
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    await FirebaseQueryHelper.firebaseFireStore
                                        .collection('bookings')
                                        .doc(
                                            "${FirebaseAuth.instance.currentUser!.uid}:$patientID")
                                        .update({'status': "rejected"});
                                  },
                                  child: const Text("Reject"),
                                ),
                                TextButton(
                                  onPressed: () async =>
                                      await onAccept(patientID, scheduleID),
                                  child: const Text("Accept"),
                                )
                              ],
                            )
                          }
                        ],
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text("No Request Today"),
                );
        },
      ),
    );
  }

  Future<void> onAccept(String patientID, String? scheduleID) async {
    await FirebaseQueryHelper.firebaseFireStore
        .collection('bookings')
        .doc("${FirebaseAuth.instance.currentUser!.uid}:$patientID")
        .update({'status': "accepted"});
    await FirebaseQueryHelper.firebaseFireStore
        .collection('time')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      final allTimes = value['times'] as List<dynamic>;
      if (allTimes.isNotEmpty) {
        List<dynamic> list = allTimes
            .map((e) => {
                  'isBooked': e['isBooked'],
                  'scheduleID': e['scheduleID'],
                  'startTime': e['startTime'],
                  'endTime': e['endTime'],
                  'createdOn': e['createdOn']
                })
            .toList();
        final foundTime = list.firstWhere((element) {
          return element['scheduleID'] == scheduleID;
        }) as Map<String, dynamic>?;
        if (foundTime != null) {
          int? i = list.indexWhere(
              (element) => element['scheduleID'] == foundTime['scheduleID']);
          final test = list.elementAt(i) as Map<String, dynamic>?;
          list.removeAt(i);
          if (test != null) {
            test.update('isBooked', (value) => true);
            list.add(test);
          }
          FirebaseQueryHelper.firebaseFireStore
              .collection('time')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .set({'times': list});
        }
      }
    });
  }
}
