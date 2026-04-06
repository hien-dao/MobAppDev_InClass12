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
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  Stream<List<Item>>? _itemsStream;

  @override
  void initState() {
    super.initState();
    _itemsStream = DatabaseHelper().streamItems();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _itemsStream = DatabaseHelper().queryItems(
        search: _searchController.text,
        min: int.tryParse(_minPriceController.text),
        max: int.tryParse(_maxPriceController.text),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Inventory App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _searchController,
                    decoration: const InputDecoration(labelText: 'Search by name'),
                    onChanged: (_) => _applyFilters(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _minPriceController,
                          decoration: const InputDecoration(labelText: 'Min Amount'),
                          keyboardType: TextInputType.number,
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _maxPriceController,
                          decoration: const InputDecoration(labelText: 'Max Amount'),
                          keyboardType: TextInputType.number,
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Item>>(
              stream: _itemsStream,
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
          ),
        ],
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