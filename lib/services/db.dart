import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './globals.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class Document<T> {
  final Firestore _db = Firestore.instance;
  final String path;
  DocumentReference ref;

  Document({this.path}) {
    ref = _db.document(path);
  }

  Future<T> getData() {
    // return ref.get().then((v) => (v.data) as T);
    // return ref.get().then((v) => Global.models[T](v.data) as T);
  }

  Stream<T> streamData() {
    // return ref.snapshots().map((v) => Global.models[T](v.data) as T);
  }

  // set document in collection or merge with existing if exists
  Future<void> upsert(Map data) {
    return ref.setData(Map<String, dynamic>.from(data), merge: true);
  }

  // final segments = path.split('/');
  //   if (segments.length % 2 == 0) {
  //     print('segemnts' + segments.toString());
  //     print('custom key: ' + segments[segments.length - 1]);
  //     // has custom key passed in - last element in segments
  //     return ref
  //         .document(segments[segments.length - 1])
  //         .setData(Map<String, dynamic>.from(data));
  //   } else {
  //     print('auto adding');
  //     // use uato add

  //   }
}

class Collection<T> {
  final Firestore _db = Firestore.instance;
  final String path;
  final String query; // this isn't implemented yet.

  CollectionReference ref;

  Collection({this.path, this.query}) {
    ref = _db.collection(path);
  }

  Future<List<T>> getData() async {
    var snapshots = await ref.getDocuments();
    return snapshots.documents
        .map((doc) => Global.models[T](doc.data, doc.documentID) as T)
        .toList();
    // return snapshots.documents
    // .map((doc) => Global.models[T](doc.data, doc.documentID) as T)
    // .toList();
  }

  Stream<List<T>> streamData() {
    // return ref.snapshots().map((list) => list.documents
    //     .map((doc) => Global.models[T](doc.data, doc.documentID) as T));
  }

  /// add to collection using auto id - for custom, see above in document
  /// https://stackoverflow.com/questions/55328838/flutter-firestore-add-new-document-with-custom-id
  Future<DocumentReference> addDoc(Map data) {
    return ref.add(Map<String, dynamic>.from(data));
  }
}
