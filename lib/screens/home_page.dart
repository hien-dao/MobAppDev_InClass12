import 'package:flutter/material.dart';

import '../data/database_helper.dart';
import '../data/item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
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

          if (items.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No items yet!')
              );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text('Amount: ${item.amount}\n${item.description}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _nameController.text = item.name;
                          _amountController.text = item.amount.toString();
                          _descriptionController.text = item.description;
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Edit Item'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(labelText: 'Name'),
                                    validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
                                  ),
                                  TextFormField(
                                    controller: _amountController,
                                    decoration: const InputDecoration(labelText: 'Amount'),
                                    keyboardType: TextInputType.number,
                                    validator: (value) => value == null || value.isEmpty ? 'Please enter an amount' : null,
                                  ),
                                  TextFormField(
                                    controller: _descriptionController,
                                    decoration: const InputDecoration(labelText: 'Description'),
                                    validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      final updatedItem = Item(
                                        id: item.id,
                                        name: _nameController.text,
                                        amount: int.tryParse(_amountController.text) ?? 0,
                                        description: _descriptionController.text,
                                      );
                                      DatabaseHelper().updateItem(updatedItem);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => DatabaseHelper().deleteItem(item.id),
                      ),
                    ],
                  ),
                ),
              );
            }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _nameController.clear();
          _amountController.clear();
          _descriptionController.clear();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
                  ),
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Please enter an amount' : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newItem = Item(
                        id: '',
                        name: _nameController.text,
                        amount: int.tryParse(_amountController.text) ?? 0,
                        description: _descriptionController.text,
                      );
                      DatabaseHelper().addItem(newItem);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}