import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../services/firebase/firebase_query_handler.dart';

class TherapistController {
  TherapistController();

  Stream<DocumentSnapshot<Map<String, dynamic>>> getAllBookings(
      {required String uid, required String therapistID}) {
    return FirebaseQueryHelper.firebaseFireStore
        .collection('bookings')
        .doc("$therapistID:$uid")
        .snapshots();
  }

  Future<void> onTherapistBookingRequest(
      {required String startTime,
      required String endTime,
      required String username,
      required String uid,
      required String therapistID,
      String? scheduleID}) async {
    Map<String, dynamic> patientDetail = {};
    Map<String, dynamic> therapistDetail = {};
    await FirebaseQueryHelper.firebaseFireStore
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      if (value.data() != null) {
        patientDetail = value.data()!;
      }
    });
    await FirebaseQueryHelper.firebaseFireStore
        .collection('users')
        .doc(therapistID)
        .get()
        .then((value) {
      if (value.data() != null) {
        therapistDetail = value.data()!;
      }
    });
    final data = {
      'scheduleID': scheduleID,
      'patient': patientDetail,
      'therapist': therapistDetail,
      'startTime': startTime,
      'endTime': endTime,
      'patientId': uid,
      'therapistId': therapistID,
      'status': "pending",
      'requestedOn': DateTime.now(),
    };

    await FirebaseQueryHelper.firebaseFireStore
        .collection('bookings')
        .doc("$therapistID:$uid")
        .set(data);
  }
}

final therapistController = TherapistController();
