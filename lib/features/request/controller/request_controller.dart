import 'package:firebase_auth/firebase_auth.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';

class RequestController {
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

RequestController requestController = RequestController();
