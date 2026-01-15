import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../view_models/product_view_model.dart';

class StockUpdateScreen extends ConsumerStatefulWidget {
  final Product product;

  const StockUpdateScreen({Key? key, required this.product}) : super(key: key);

  @override
  ConsumerState<StockUpdateScreen> createState() => _StockUpdateScreenState();
}

class _StockUpdateScreenState extends ConsumerState<StockUpdateScreen> {
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  String _operationType = 'in';
  bool _isLoading = false;

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _updateStock() async {
    if (_quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter quantity')),
      );
      return;
    }

    final quantity = int.tryParse(_quantityController.text);
    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid quantity')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      int newStock;
      int changeAmount;
      String changeType;

      if (_operationType == 'in') {
        newStock = widget.product.currentStock + quantity;
        changeAmount = quantity;
        changeType = 'increment';
      } else {
        if (widget.product.currentStock < quantity) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Insufficient stock!')),
          );
          setState(() => _isLoading = false);
          return;
        }
        newStock = widget.product.currentStock - quantity;
        changeAmount = -quantity;
        changeType = 'decrement';
      }

      await ref.read(productListProvider.notifier).updateStock(
            widget.product.id,
            newStock,
            changeAmount,
            changeType,
          );

      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Stock ${_operationType == 'in' ? 'added' : 'removed'} successfully',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Stock'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Product ID: ${widget.product.id}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text(
                                'Current Stock: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${widget.product.currentStock}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: widget.product.currentStock > 10
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Operation Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildOperationTypeCard(
                          'Stock In',
                          'in',
                          Icons.add_circle,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildOperationTypeCard(
                          'Stock Out',
                          'out',
                          Icons.remove_circle,
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      hintText: 'Enter quantity',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.numbers),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              final current =
                                  int.tryParse(_quantityController.text) ?? 0;
                              if (current > 0) {
                                _quantityController.text =
                                    (current - 1).toString();
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              final current =
                                  int.tryParse(_quantityController.text) ?? 0;
                              _quantityController.text =
                                  (current + 1).toString();
                            },
                          ),
                        ],
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes (Optional)',
                      hintText: 'Add notes about this transaction',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.note_alt),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  if (_quantityController.text.isNotEmpty &&
                      int.tryParse(_quantityController.text) != null)
                    Card(
                      color: Colors.blue[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Preview:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Current Stock:'),
                                Text(
                                  '${widget.product.currentStock}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _operationType == 'in'
                                      ? 'Adding:'
                                      : 'Removing:',
                                ),
                                Text(
                                  '${_operationType == 'in' ? '+' : '-'}${_quantityController.text}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: _operationType == 'in'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'New Stock:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  _calculateNewStock().toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _updateStock,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _operationType == 'in' ? Colors.green : Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Confirm ${_operationType == 'in' ? 'Stock In' : 'Stock Out'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Last updated: ${DateFormat('MMM dd, yyyy - hh:mm a').format(DateTime.now())}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildOperationTypeCard(
    String title,
    String type,
    IconData icon,
    Color color,
  ) {
    final isSelected = _operationType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _operationType = type;
        });
      },
      child: Card(
        elevation: isSelected ? 5 : 2,
        color: isSelected ? color.withOpacity(0.1) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
                color: isSelected ? color : Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateNewStock() {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    if (_operationType == 'in') {
      return widget.product.currentStock + quantity;
    } else {
      return (widget.product.currentStock - quantity).clamp(0, 999999);
    }
  }
}
