import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:you_matter/core/utils/snackbar.dart';

class FirebaseQueryHelper {
  FirebaseQueryHelper._();
  static final firebaseFireStore = FirebaseFirestore.instance;
  static Future<QuerySnapshot<Map<String, dynamic>>?> getCollectionsAsFuture(
      {required String collectionPath}) async {
    try {
      final data = await firebaseFireStore.collection(collectionPath).get();
      return data;
    } on FirebaseException catch (e) {
      showSnackBar(
          message: e.message ?? "Something Went Wrong!!",
          type: SnackBarTypes.error);
    }
    return null;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>? getCollectionsAsStream(
      {required String collectionPath}) {
    try {
      final data = firebaseFireStore.collection(collectionPath).snapshots();
      return data;
    } on FirebaseException catch (e) {
      showSnackBar(
          message: e.message ?? "Something Went Wrong!!",
          type: SnackBarTypes.error);
    }
    return null;
  }

  static Future<DocumentSnapshot?> getSingleDocument(
      {required String collectionPath, required String docID}) async {
    try {
      var data =
          await firebaseFireStore.collection(collectionPath).doc(docID).get();
      return data;
    } on FirebaseException catch (e) {
      showSnackBar(
          message: e.message ?? "Something Went Wrong!!",
          type: SnackBarTypes.error);
    }
    return null;
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>>?
      getSingleDocumentAsStream(
          {required String collectionPath, required String docID}) {
    try {
      var data =
          firebaseFireStore.collection(collectionPath).doc(docID).snapshots();
      return data;
    } on FirebaseException catch (e) {
      showSnackBar(
          message: e.message ?? "Something Went Wrong!!",
          type: SnackBarTypes.error);
    }
    return null;
  }

  static void addDocumentToCollection(
      {required Map<String, dynamic> data,
      required String collectionID}) async {
    try {
      await firebaseFireStore.collection(collectionID).add(data);
      showSnackBar(
          message: "successfully Created!!", type: SnackBarTypes.success);
    } on FirebaseException catch (e) {
      showSnackBar(
          message: e.message ?? "Something Went Wrong!!",
          type: SnackBarTypes.error);
    }
  }

  static void addDataToDocument({
    required String data,
    required String collectionID,
    required String docID,
  }) async {
    try {
      var categoriesArray =
          firebaseFireStore.collection(collectionID).doc(docID);
      categoriesArray.update({
        'expense_type': FieldValue.arrayUnion([data])
      });
      showSnackBar(
          message: "successfully Created!!", type: SnackBarTypes.success);
    } on FirebaseException catch (e) {
      showSnackBar(
          message: e.message ?? "Something Went Wrong!!",
          type: SnackBarTypes.error);
    }
  }

  static void updateDocumentOfCollection(
      {required Map<String, dynamic> data,
      required String collectionID,
      required String docID}) async {
    try {
      await firebaseFireStore.collection(collectionID).doc(docID).update(data);
      showSnackBar(
          message: "successfully Updated!!", type: SnackBarTypes.success);
    } on FirebaseException catch (e) {
      showSnackBar(
          message: e.message ?? "Something Went Wrong!!",
          type: SnackBarTypes.error);
    }
  }

  static void deleteDocumentOfCollection(
      {required String collectionID, required String docID}) async {
    try {
      await firebaseFireStore.collection(collectionID).doc(docID).delete();
      showSnackBar(
          message: "successfully Deleted!!", type: SnackBarTypes.success);
    } on FirebaseException catch (e) {
      showSnackBar(
          message: e.message ?? "Something Went Wrong!!",
          type: SnackBarTypes.error);
    }
  }
}
