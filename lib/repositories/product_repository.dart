import '../models/product.dart';
import '../models/stock_history.dart';
import '../utils/database_helper.dart';

class ProductRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> addProduct(Product product) async {
    await _dbHelper.insertProduct(product);
  }

  Future<List<Product>> getAllProducts() async {
    return await _dbHelper.getAllProducts();
  }

  Future<Product?> getProductById(String id) async {
    return await _dbHelper.getProduct(id);
  }

  Future<void> updateProduct(Product product) async {
    await _dbHelper.updateProduct(product);
  }

  Future<void> deleteProduct(String id) async {
    await _dbHelper.deleteProduct(id);
  }

  Future<List<Product>> searchProducts(String query) async {
    return await _dbHelper.searchProducts(query);
  }

  Future<void> updateStock(
    String productId,
    int newStock,
    int changeAmount,
    String changeType,
  ) async {
    final product = await _dbHelper.getProduct(productId);
    if (product != null) {
      final updatedProduct = product.copyWith(currentStock: newStock);
      await _dbHelper.updateProduct(updatedProduct);

      final history = StockHistory(
        productId: productId,
        changeAmount: changeAmount,
        stockAfterChange: newStock,
        timestamp: DateTime.now(),
        changeType: changeType,
      );
      await _dbHelper.insertStockHistory(history);
    }
  }

  Future<List<StockHistory>> getProductHistory(String productId) async {
    return await _dbHelper.getProductHistory(productId);
  }

  Future<bool> isProductIdUnique(String id) async {
    final product = await _dbHelper.getProduct(id);
    return product == null;
  }
}
