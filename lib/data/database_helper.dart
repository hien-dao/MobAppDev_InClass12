import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'item.dart';

final itemsRef = FirebaseFirestore.instance.collection('items');

Future<void> addItem(Item item) async {
  await itemsRef.add(item.toMap());
}

Stream<List<Item>> streamItems() {
  return itemsRef.snapshots().map(
    (snap) => snap.docs.map((d) => Item.fromMap(d.id, d.data())).toList(),
  );
}

Future<void> updateItem(Item item) async {
  await itemsRef.doc(item.id).update(item.toMap());
}

Future<void> deleteItem(String id) async {
  await itemsRef.doc(id).delete();
}