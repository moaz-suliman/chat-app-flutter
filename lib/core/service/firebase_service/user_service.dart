import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    await database.collection('users').doc(uid).set(data);
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    return await database.collection('users').doc(uid).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUsers() async {
  return await database.collection('users').get();
}

}   