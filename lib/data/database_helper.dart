import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'item.dart';

class DatabaseHelper {

  final itemsRef = FirebaseFirestore.instance.collection('items');

  Future<void> addItem(Item item) async {
    await itemsRef.add(item.toMap());
  }

  Stream<List<Item>> streamItems() {
    return itemsRef.snapshots().map(
      (snap) => snap.docs.map((d) => Item.fromMap(d.data() as Map<String, dynamic>, d.id)).toList(),
    );
  }

  Future<void> updateItem(Item item) async {
    await itemsRef.doc(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String id) async {
    await itemsRef.doc(id).delete();
  }

  Stream<List<Item>> queryItems({
    String? search,
    int? min,
    int? max,
  }) {
    Query query = itemsRef;

    if (search != null && search.isNotEmpty) {
      query = query
        .where('name', isGreaterThanOrEqualTo: search)
        .where('name', isLessThanOrEqualTo: search + '\uf8ff');
    }

    if (min != null) {
      query = query.where('amount', isGreaterThanOrEqualTo: min);
    }

    if (max != null) {
      query = query.where('amount', isLessThanOrEqualTo: max);
    }

    return query.snapshots().map(
      (snap) => snap.docs.map((d) => Item.fromMap(d.data() as Map<String, dynamic>, d.id)).toList(),
    );
  }
}