import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shoffee/models/coffee_model.dart';
import 'package:coffee_shoffee/models/user_model.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference coffeeCollection =
      Firestore.instance.collection("coffees");

  //create document for the user on signup

  Future updateUserData(String sugars, String name, int strength) async {
    return await coffeeCollection
        .document(uid)
        .setData({'sugars': sugars, 'name': name, 'strength': strength});
  }

  List<Coffee> _coffeeFromQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Coffee(
          name: doc.data["name"] ?? '',
          sugars: doc.data["sugars"] ?? '0',
          strength: doc.data["strength"] ?? 0);
    }).toList();
  }

  UserData _userDataFromDocumentSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data["name"] ?? '',
        sugars: snapshot.data["sugars"] ?? '0',
        strength: snapshot.data["strength"] ?? 0);
  }

  //streams of coffee collection
  Stream<List<Coffee>> get coffees {
    return coffeeCollection.snapshots().map(_coffeeFromQuerySnapshot);
  }

  //streams userdata of coffee
  Stream<UserData> get userData {
    return coffeeCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromDocumentSnapshot);
  }
}
