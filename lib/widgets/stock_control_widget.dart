import 'package:flutter/material.dart';

class StockControlWidget extends StatelessWidget {
  final int currentStock;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const StockControlWidget({
    Key? key,
    required this.currentStock,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Current Stock:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              IconButton(
                onPressed: currentStock > 0 ? onDecrement : null,
                icon: const Icon(Icons.remove_circle),
                color: Colors.red,
                iconSize: 32,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  '$currentStock',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: onIncrement,
                icon: const Icon(Icons.add_circle),
                color: Colors.green,
                iconSize: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
