import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_event.dart';
import '../bloc/address_state.dart';
import 'add_edit_address_screen.dart';
import '../../domain/entities/address.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(LoadAddresses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditAddressScreen()),
          ).then((_) => context.read<AddressBloc>().add(LoadAddresses()));
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state is AddressLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AddressesLoaded) {
            if (state.addresses.isEmpty) {
              return const Center(child: Text('No addresses yet'));
            }
            return ListView.builder(
              itemCount: state.addresses.length,
              itemBuilder: (context, index) {
                final address = state.addresses[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(address.fullName),
                    subtitle: Text(
                        '${address.street}, ${address.city}, ${address.state} ${address.zip}\n${address.phone}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context.read<AddressBloc>().add(DeleteAddress(address.id));
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEditAddressScreen(address: address),
                        ),
                      ).then((_) => context.read<AddressBloc>().add(LoadAddresses()));
                    },
                  ),
                );
              },
            );
          } else if (state is AddressError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}