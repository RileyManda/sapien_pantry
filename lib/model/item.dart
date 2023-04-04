class Item {
  String id;
  String catId;
  String text;
  String category;
  int? quantity;
  int? price;
  String? unit;
  String? expiryDate;


  Item({
    required this.id,
    required this.catId,
    required this.text,
    required this.category,
    this.quantity,
    this.price,
    this.unit,
    this.expiryDate,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] ?? '',
      catId: map['catId'] ?? '',
      text: map['text'],
      category: map['category'],
      quantity: map['quantity'] ?? 0,
      price: map['price'] ?? 0,
      unit: map['unit'],
      expiryDate: 'expiryDate',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'catId': catId,
      'text': text,
      'category': category,
      'quantity': quantity,
      'price': price,
      'unit': unit,
      'expiryDate': expiryDate,
    };
  }
}
