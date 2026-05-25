import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../../features/product/domain/entities/product.dart';
import '../bloc/admin_product_bloc.dart';
import '../bloc/admin_product_event.dart';
import '../bloc/admin_product_state.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({super.key});

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminProductBloc>().add(LoadAdminProducts());
  }

  void _showAddEditDialog({Product? product}) {
    final nameCtrl = TextEditingController(text: product?.name ?? '');
    final descCtrl = TextEditingController(text: product?.description ?? '');
    final priceCtrl = TextEditingController(text: product?.price.toString() ?? '');
    final imageUrlCtrl = TextEditingController(text: product?.imageUrls.join(', ') ?? '');
    final categoryCtrl = TextEditingController(text: product?.category ?? '');
    final stockCtrl = TextEditingController(text: product?.stockQuantity.toString() ?? '');
    final ratingCtrl = TextEditingController(text: product?.rating.toString() ?? '');
    final reviewCtrl = TextEditingController(text: product?.reviewCount.toString() ?? '');
    final discountCtrl = TextEditingController(text: product?.discountPercent?.toString() ?? '');
    final sizesCtrl = TextEditingController(text: product?.sizes.join(', ') ?? '');
    final colorsCtrl = TextEditingController(text: product?.colors.join(', ') ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(product == null ? 'Add Product' : 'Edit Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
              TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Price')),
              TextField(controller: imageUrlCtrl, decoration: const InputDecoration(labelText: 'Image URLs (comma separated)')),
              TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: 'Category')),
              TextField(controller: stockCtrl, decoration: const InputDecoration(labelText: 'Stock Quantity')),
              TextField(controller: ratingCtrl, decoration: const InputDecoration(labelText: 'Rating')),
              TextField(controller: reviewCtrl, decoration: const InputDecoration(labelText: 'Review Count')),
              TextField(controller: discountCtrl, decoration: const InputDecoration(labelText: 'Discount %')),
              TextField(controller: sizesCtrl, decoration: const InputDecoration(labelText: 'Sizes (comma separated)')),
              TextField(controller: colorsCtrl, decoration: const InputDecoration(labelText: 'Colors (comma separated)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final newProduct = Product(
                id: product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameCtrl.text,
                description: descCtrl.text,
                price: double.tryParse(priceCtrl.text) ?? 0.0,
                imageUrls: imageUrlCtrl.text.split(',').map((e) => e.trim()).toList(),
                category: categoryCtrl.text,
                stockQuantity: int.tryParse(stockCtrl.text) ?? 0,
                rating: double.tryParse(ratingCtrl.text) ?? 0.0,
                reviewCount: int.tryParse(reviewCtrl.text) ?? 0,
                discountPercent: double.tryParse(discountCtrl.text),
                sizes: sizesCtrl.text.split(',').map((e) => e.trim()).toList(),
                colors: colorsCtrl.text.split(',').map((e) => e.trim()).toList(),
              );
              if (product == null) {
                context.read<AdminProductBloc>().add(AddAdminProduct(newProduct));
              } else {
                context.read<AdminProductBloc>().add(UpdateAdminProduct(newProduct));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin - Products')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<AdminProductBloc, AdminProductState>(
        listener: (context, state) {
          if (state is AdminProductSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Operation successful')),
            );
          } else if (state is AdminProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AdminProductsLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('\$${product.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showAddEditDialog(product: product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<AdminProductBloc>().add(DeleteAdminProduct(product.id));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}