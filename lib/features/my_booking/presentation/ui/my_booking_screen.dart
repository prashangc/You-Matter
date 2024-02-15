import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/sizes.dart';
import '../../../../services/firebase/firebase_query_handler.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({
    super.key,
  });

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
      ),
      body: StreamBuilder(
        stream: FirebaseQueryHelper.firebaseFireStore
            .collection('bookings')
            .snapshots(),
        builder: (context, snapshot) {
          final bookings = snapshot.data?.docs
              .where((element) =>
                  element.id.split(":").last ==
                  FirebaseAuth.instance.currentUser!.uid)
              .toList();

          return Expanded(
              child: ListView.separated(
            separatorBuilder: (context, index) {
              return sizedBox12();
            },
            itemCount: bookings?.length ?? 0,
            itemBuilder: (context, index) {
              final booking = bookings?[index].data();
              final requestedOn = booking?['requestedOn'] as Timestamp;
              final patientID = booking?['patientId'] as String;
              final status = booking?['status'] as String;
              bool isRejected = status == "rejected";
              bool isAccepted = status == "accepted";
              bool isPending = status == "pending";
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
                        Text(
                          status,
                          style: TextStyle(
                            color: isRejected
                                ? Colors.red
                                : isAccepted
                                    ? Colors.green
                                    : isPending
                                        ? Colors.blue
                                        : null,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            "Requested On:  ${DateFormat("EEEE, MMM d").format(requestedOn.toDate())}"),
                        Text("Patient Name: ${booking?['patient']}"),
                        Text(
                            "Date and time: ${booking?['date']} ${booking?['time']}")
                      ],
                    ),
                  ],
                ),
              );
            },
          ));
        },
      ),
    );
  }
}
