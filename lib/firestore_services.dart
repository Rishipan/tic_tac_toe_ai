import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createRoom() async {
    String roomId = _generateRoomId();
    DateTime now = DateTime.now();
    DateTime expirationTime = now.add(const Duration(minutes: 10));

    Map<String, dynamic> board = {
      'row0': ['', '', ''],
      'row1': ['', '', ''],
      'row2': ['', '', ''],
    };

    await _db.collection('rooms').doc(roomId).set({
      'board': board,
      'currentPlayer': 'X',
      'expirationTime': expirationTime,
    });

    return roomId;
  }

  String _generateRoomId() {
    final random = Random();
    return (10000 + random.nextInt(90000)).toString();
  }

  Future<DocumentSnapshot> getRoom(String roomId) {
    return _db.collection('rooms').doc(roomId).get();
  }

  Future<void> joinRoom(String roomId) async {
    DocumentSnapshot roomSnapshot = await getRoom(roomId);
    if (!roomSnapshot.exists) {
      throw Exception('Room does not exist');
    }
  }

  Stream<DocumentSnapshot> listenToRoom(String roomId) {
    return _db.collection('rooms').doc(roomId).snapshots();
  }

  Future<void> updateRoom(String roomId, Map<String, dynamic> data) {
    return _db.collection('rooms').doc(roomId).update(data);
  }
}
