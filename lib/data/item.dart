class Item {
  String id;
  String name;
  int amount;
  String description;

  Item({required this.id, required this.name, required this.amount, required this.description});

  factory Item.fromMap(Map<String, dynamic> data, String documentId) {
    return Item(
      id: documentId,
      name: data['name'] ?? '',
      amount: data['amount'] ?? 0,
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'description': description,
    };
  }
}