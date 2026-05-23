import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/address.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_event.dart';
import '../bloc/address_state.dart';

class AddEditAddressScreen extends StatefulWidget {
  final Address? address;
  const AddEditAddressScreen({super.key, this.address});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _streetCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _stateCtrl;
  late TextEditingController _zipCtrl;

  @override
  void initState() {
    super.initState();
    final addr = widget.address;
    _fullNameCtrl = TextEditingController(text: addr?.fullName ?? '');
    _phoneCtrl = TextEditingController(text: addr?.phone ?? '');
    _streetCtrl = TextEditingController(text: addr?.street ?? '');
    _cityCtrl = TextEditingController(text: addr?.city ?? '');
    _stateCtrl = TextEditingController(text: addr?.state ?? '');
    _zipCtrl = TextEditingController(text: addr?.zip ?? '');
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final address = Address(
        id: widget.address?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: _fullNameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        street: _streetCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        state: _stateCtrl.text.trim(),
        zip: _zipCtrl.text.trim(),
        isDefault: widget.address?.isDefault ?? false,
      );

      if (widget.address == null) {
        context.read<AddressBloc>().add(AddAddress(address));
      } else {
        context.read<AddressBloc>().add(UpdateAddress(address));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
      ),
      body: BlocProvider(
        create: (_) => sl<AddressBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _fullNameCtrl,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneCtrl,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _streetCtrl,
                  decoration: const InputDecoration(labelText: 'Street'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _cityCtrl,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _stateCtrl,
                  decoration: const InputDecoration(labelText: 'State'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _zipCtrl,
                  decoration: const InputDecoration(labelText: 'ZIP Code'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}