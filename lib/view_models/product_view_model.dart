import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../models/stock_history.dart';
import '../repositories/product_repository.dart';

// Repository Provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

// Product List State Notifier
class ProductListNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductRepository _repository;

  ProductListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    try {
      final products = await _repository.getAllProducts();
      state = AsyncValue.data(products);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _repository.addProduct(product);
      await loadProducts();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _repository.updateProduct(product);
      await loadProducts();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _repository.deleteProduct(id);
      await loadProducts();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStock(
    String productId,
    int newStock,
    int changeAmount,
    String changeType,
  ) async {
    try {
      await _repository.updateStock(
        productId,
        newStock,
        changeAmount,
        changeType,
      );
      await loadProducts();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    return await _repository.searchProducts(query);
  }

  Future<bool> isProductIdUnique(String id) async {
    return await _repository.isProductIdUnique(id);
  }
}

// Provider for Product List
final productListProvider =
    StateNotifierProvider<ProductListNotifier, AsyncValue<List<Product>>>((
  ref,
) {
  final repository = ref.watch(productRepositoryProvider);
  return ProductListNotifier(repository);
});

// Provider for Stock History (Bonus)
final stockHistoryProvider = FutureProvider.family<List<StockHistory>, String>((
  ref,
  productId,
) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getProductHistory(productId);
});

// Search Query Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filtered Products Provider
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productListProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  return productsAsync.when(
    data: (products) {
      if (searchQuery.isEmpty) {
        return AsyncValue.data(products);
      }
      final filtered = products
          .where((p) => p.id.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});
