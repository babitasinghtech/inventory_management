import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../view_models/product_view_model.dart';
import '../widgets/stock_control_widget.dart';
import 'add_edit_product_screen.dart';
import 'stock_update_screen.dart';
import 'stock_history_screen.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockHistoryAsync = ref.watch(stockHistoryProvider(product.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditProductScreen(product: product),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (product.imagePath != null)
              Image.file(
                File(product.imagePath!),
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholder(),
              )
            else
              _buildPlaceholder(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ID: ${product.id}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    StockUpdateScreen(product: product),
                              ),
                            );
                            if (result == true) {
                              ref.invalidate(stockHistoryProvider(product.id));
                            }
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Update Stock'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    StockHistoryScreen(product: product),
                              ),
                            );
                          },
                          icon: const Icon(Icons.history),
                          label: const Text('View History'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  StockControlWidget(
                    currentStock: product.currentStock,
                    onIncrement: () async {
                      await ref.read(productListProvider.notifier).updateStock(
                            product.id,
                            product.currentStock + 1,
                            1,
                            'increment',
                          );
                      ref.invalidate(stockHistoryProvider(product.id));
                    },
                    onDecrement: () async {
                      if (product.currentStock > 0) {
                        await ref
                            .read(productListProvider.notifier)
                            .updateStock(
                              product.id,
                              product.currentStock - 1,
                              -1,
                              'decrement',
                            );
                        ref.invalidate(stockHistoryProvider(product.id));
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildInfoRow('Added By', product.addedBy),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Added On',
                    DateFormat('MMM dd, yyyy - hh:mm a')
                        .format(product.timestamp),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Stock History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  stockHistoryAsync.when(
                    data: (history) {
                      if (history.isEmpty) {
                        return const Text('No stock changes yet');
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final item = history[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Icon(
                                item.changeType == 'increment'
                                    ? Icons.add_circle
                                    : Icons.remove_circle,
                                color: item.changeType == 'increment'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              title: Text(
                                '${item.changeType == 'increment' ? '+' : ''}${item.changeAmount}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: item.changeType == 'increment'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('MMM dd, yyyy - hh:mm a')
                                    .format(item.timestamp),
                              ),
                              trailing: Text(
                                'Stock: ${item.stockAfterChange}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Text('Error: $err'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 250,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.inventory_2, size: 80, color: Colors.grey),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}
