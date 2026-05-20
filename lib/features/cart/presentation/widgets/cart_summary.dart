import 'package:flutter/material.dart';

class CartSummary extends StatelessWidget {
  final double total;
  final int itemCount;
  final VoidCallback onCheckout;
  final VoidCallback onClear;

  const CartSummary({
    super.key,
    required this.total,
    required this.itemCount,
    required this.onCheckout,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total ($itemCount items):',
                  style: const TextStyle(fontSize: 16)),
              Text('\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onCheckout,
                  icon: const Icon(Icons.payment),
                  label: const Text('Checkout'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(14)),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: onClear,
                icon: const Icon(Icons.delete_sweep),
                label: const Text('Clear'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(14),
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}