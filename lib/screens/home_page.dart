import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/database_helper.dart';
import '../data/item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void initState() {
    super.initState();
  }

  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Inventory App'),
      ),
      body: StreamBuilder<List<Item>>(
        stream: DatabaseHelper().streamItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          final items = snapshot.data ?? [];
          if (items.isEmpty) return const Text('No items yet.');
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) => ListTile(title: Text(items[i].name)),
          );
        },
      ),
    );
  }
}