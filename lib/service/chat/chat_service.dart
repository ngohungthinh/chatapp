import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user stream
  /*
  [
  { 
    'email': test@gmail.com,
    'id':..
  },
  { 
    'email': thinh@gmail.com,
    'id':..
  },
  ]
  */
  // GET USER STREAM
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("User").snapshots().map((snapshot) {
      return snapshot.docs.map(
        (doc) {
          // go through each individual user
          final Map<String, dynamic> user = doc.data();
          return user;
        },
      ).toList();
    });
  }

  // GET ALL USER EXCEPT BLOCKED USERS
  Stream<List<Map<String, dynamic>>> getUsersStreamExcludingBlocked() {
    final currentUser = _auth.currentUser;

    return _firestore
        .collection('User')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((querySnapshot) async {
      // get blocked user ids
      final blockedUserIds = querySnapshot.docs.map((doc) => doc.id).toList();

      // get all users
      final usersSnapshot = await _firestore
          .collection('User')
          .where('email', isNotEqualTo: currentUser.email)
          .get();

      // return as stream list
      return usersSnapshot.docs
          .where((docSnap) => !blockedUserIds.contains(docSnap.id))
          .map((docSnap) => docSnap.data())
          .toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverID, message) async {
    //get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // REPORT USER
  Future<void> reportUser(String messageId, String userId) async {
    final currentUser = _auth.currentUser;
    final report = {
      'reportedBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection("Reports").add(report);
  }

  // BLOCK USER
  Future<void> blockUser(String blockedUserId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('User')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockedUserId)
        .set({});

    notifyListeners();
  }

  // UNBLOCK USER
  Future<void> unBlockUser(String blockedUserId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('User')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockedUserId)
        .delete();
  }

  // GET BLOCKED USERS STREAM
  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userId) {
    return _firestore
        .collection("User")
        .doc(userId)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((querysnapshot) async {
      final blockedUserIds = querysnapshot.docs.map((doc) => doc.id).toList();

      // var value = await Future.wait([delayedNumber(), delayedString()]);
      final userDocs = await Future.wait(
        blockedUserIds.map(
          (id) => _firestore.collection('User').doc(id).get(),
        ),
      );

      return userDocs.map((doc) => doc.data()!).toList();
    });
  }
}
