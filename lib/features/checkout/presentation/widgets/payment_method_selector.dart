import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatefulWidget {
  const PaymentMethodSelector({super.key});

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  String? _selectedMethod = 'cash';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
        RadioListTile<String>(
          title: const Text('Cash on Delivery'),
          value: 'cash',
          groupValue: _selectedMethod,
          onChanged: (val) => setState(() => _selectedMethod = val),
        ),
        RadioListTile<String>(
          title: const Text('Credit Card'),
          value: 'card',
          groupValue: _selectedMethod,
          onChanged: (val) => setState(() => _selectedMethod = val),
        ),
      ],
    );
  }
}