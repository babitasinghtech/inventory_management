class Product {
  final String id; // 5 alphanumeric characters
  final String name;
  final String description;
  final int currentStock;
  final String? imagePath;
  final DateTime timestamp;
  final String addedBy;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.currentStock,
    this.imagePath,
    required this.timestamp,
    required this.addedBy,
  });

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'currentStock': currentStock,
      'imagePath': imagePath,
      'timestamp': timestamp.toIso8601String(),
      'addedBy': addedBy,
    };
  }

  // Create Product from Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      currentStock: map['currentStock'] as int,
      imagePath: map['imagePath'] as String?,
      timestamp: DateTime.parse(map['timestamp'] as String),
      addedBy: map['addedBy'] as String,
    );
  }

  // Copy with method for updates
  Product copyWith({
    String? name,
    String? description,
    int? currentStock,
    String? imagePath,
    DateTime? timestamp,
    String? addedBy,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      currentStock: currentStock ?? this.currentStock,
      imagePath: imagePath ?? this.imagePath,
      timestamp: timestamp ?? this.timestamp,
      addedBy: addedBy ?? this.addedBy,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, stock: $currentStock}';
  }
}
