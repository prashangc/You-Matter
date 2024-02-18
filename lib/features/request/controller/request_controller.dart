import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
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

  Future<void> createChat(
      {required String patientID,
      required String startTime,
      required String endTime,
      required List<Map<String, dynamic>?> participants,
      String? scheduleID}) async {
    await FirebaseQueryHelper.firebaseFireStore
        .collection('chats')
        .doc("${FirebaseAuth.instance.currentUser!.uid}:$patientID")
        .set({
      'startTime': startTime,
      'endTime': endTime,
      'id': const Uuid().v4(),
      'scheduleID': scheduleID,
      'date': DateFormat("EEEE, MMM d").format(DateTime.now()),
      'participants': participants,
    });
  }

  Future<void> sendMessage({
    required String chatID,
    required String senderID,
    required String content,
  }) async {
    List<dynamic> allMessages = [];
    await FirebaseQueryHelper.firebaseFireStore
        .collection('chatMessages')
        .doc(chatID)
        .get()
        .then((value) {
      if (value.exists) {
        final messages = value.data();
        allMessages = messages?['messages'] as List<dynamic>;
      } else {}
    });
    allMessages.add({
      'id': const Uuid().v4(),
      'createdAt': DateFormat("EEEE, MMM d").format(DateTime.now()),
      'senderID': senderID,
      'content': content,
    });
    await FirebaseQueryHelper.firebaseFireStore
        .collection('chatMessages')
        .doc(chatID)
        .set({'messages': allMessages});
  }
}

RequestController requestController = RequestController();
