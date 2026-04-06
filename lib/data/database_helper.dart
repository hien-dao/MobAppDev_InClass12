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
      (snap) => snap.docs.map((d) => Item.fromMap(d.data(), d.id)).toList(),
    );
  }

  Future<void> updateItem(Item item) async {
    await itemsRef.doc(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String id) async {
    await itemsRef.doc(id).delete();
  }

  // Search by name
  Stream<List<Item>> searchItems(String query) {
    return itemsRef
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots()
        .map((snap) => snap.docs.map((d) => Item.fromMap(d.data(), d.id)).toList());
  }

  // Filter by amount range
  Stream<List<Item>> filterItems(int minAmount, int maxAmount) {
    return itemsRef
        .where('amount', isGreaterThanOrEqualTo: minAmount)
        .where('amount', isLessThanOrEqualTo: maxAmount)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Item.fromMap(d.data(), d.id)).toList());
  }
}