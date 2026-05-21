import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../product/presentation/screens/product_detail_screen.dart';
import '../bloc/wishlist_bloc.dart';
import '../bloc/wishlist_event.dart';
import '../bloc/wishlist_state.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistBloc>().add(LoadWishlist());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WishlistLoaded) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text('Your wishlist is empty', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return Dismissible(
                  key: Key(item.productId),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => context.read<WishlistBloc>().add(
                        ToggleWishlist(item.productId, item.productName, item.price, item.imageUrl),
                      ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                    ),
                    title: Text(item.productName),
                    subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => context.read<WishlistBloc>().add(
                            ToggleWishlist(item.productId, item.productName, item.price, item.imageUrl),
                          ),
                    ),
                    onTap: () {
                      // We need Product from wishlist item? Not directly, but we can fetch from ProductBloc.
                      // For simplicity, you can navigate to product detail by finding the product from global state.
                      // We'll skip for now or use an approach to get product by id.
                    },
                  ),
                );
              },
            );
          } else if (state is WishlistError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
