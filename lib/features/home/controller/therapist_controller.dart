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
      {required String time,
      required String date,
      required String username,
      required String uid,
      required String therapistID}) async {
    await FirebaseQueryHelper.firebaseFireStore
        .collection('bookings')
        .doc("$therapistID:$uid")
        .set({
      'patient': username,
      'time': time,
      'date': date,
      'patientId': uid,
      'therapistId': therapistID,
      'status': "pending",
      'requestedOn': DateTime.now(),
    });
  }
}

final therapistController = TherapistController();
