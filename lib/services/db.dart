import 'package:cloud_firestore/cloud_firestore.dart';
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
    return ref.get().then((v) => Global.models[T](v.data) as T);
  }

  Future<T> getDataNoTyping() {
    return ref.get().then((v) => (v.data) as T);
  }

  Stream<T> streamData() {
    return ref.snapshots().map((v) => Global.models[T](v.data) as T);
  }

  // set document in collection or merge with existing if exists
  Future<void> upsert(Map data) {
    return ref.setData(Map<String, dynamic>.from(data), merge: true);
  }

  // delete a document
  Future<void> delete() {
    return ref.delete();
  }
}

/// Will not handle queries - for now anything with query or multiple queries
/// has to have it's own class. It's possible to pass in a specific number of
/// queries, ie one or more, but i can't abstract to an unkown number of queries
/// which makes putting that in the base class pointless since you'd always
/// be confined to a single where clause.
/// There may be a way to dynamically add where clauses but I can't figure it
/// out right now and need to move on.
class Collection<T> {
  final Firestore _db = Firestore.instance;
  final String path;

  CollectionReference ref;

  Collection({this.path}) {
    ref = _db.collection(path);
  }

  Future<List<T>> getData() async {
    QuerySnapshot snapshot = await ref.getDocuments();
    return snapshot.documents
        .map((doc) => Global.models[T](doc.data, doc.documentID) as T)
        .toList();
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

class CollectionUserProducts<T> {
  final Firestore _db = Firestore.instance;
  final String path;
  final String uid;

  CollectionReference ref;

  CollectionUserProducts({this.path, this.uid}) {
    ref = _db.collection(path);
  }

  Future<List<T>> getData() async {
    QuerySnapshot snapshot =
        await ref.where('creatorUid', isEqualTo: uid).getDocuments();
    return snapshot.documents
        .map((doc) => Global.models[T](doc.data, doc.documentID) as T)
        .toList();
  }
}
