import 'package:e_com_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:e_com_app/features/product/presentation/bloc/product_state.dart';
import 'package:e_com_app/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:e_com_app/features/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:e_com_app/features/wishlist/presentation/bloc/wishlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  int _quantity = 1;
  String? _selectedSize;
  String? _selectedColor;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final hasDiscount =
        product.discountPercent != null && product.discountPercent! > 0;
    final discountedPrice = hasDiscount
        ? product.price * (1 - product.discountPercent! / 100)
        : product.price;

    // Related products (same category, excluding this one)
    final productBloc = context.read<ProductBloc>();
    final allProducts = (productBloc.state is ProductsLoaded)
        ? (productBloc.state as ProductsLoaded).products
        : <Product>[];
    final relatedProducts = allProducts
        .where((p) => p.category == product.category && p.id != product.id)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with share and wishlist (BLoC controlled)
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            actions: [
              // Wishlist heart button
              BlocBuilder<WishlistBloc, WishlistState>(
                builder: (context, state) {
                  bool isFav = false;
                  if (state is WishlistLoaded) {
                    isFav = state.items.any((item) => item.productId == product.id);
                  } else if (state is WishlistItemStatus) {
                    isFav = state.isInWishlist;
                  }
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      context.read<WishlistBloc>().add(
                            ToggleWishlist(
                              product.id,
                              product.name,
                              product.price,
                              product.imageUrls.isNotEmpty
                                  ? product.imageUrls[0]
                                  : '',
                            ),
                          );
                    },
                  );
                },
              ),
              // Share button
              IconButton(
                icon: const Icon(Icons.share, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),

          // Image Carousel
          SliverToBoxAdapter(
            child: SizedBox(
              height: 350,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: product.imageUrls.length,
                    onPageChanged: (idx) =>
                        setState(() => _currentImageIndex = idx),
                    itemBuilder: (ctx, idx) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        image: DecorationImage(
                          image: NetworkImage(product.imageUrls[idx]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Indicator dots
                  if (product.imageUrls.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          product.imageUrls.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentImageIndex == i ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == i
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Product Info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(product.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  // Rating row
                  Row(
                    children: [
                      ...List.generate(
                          5,
                          (i) => Icon(
                                i < product.rating.floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              )),
                      const SizedBox(width: 8),
                      Text('${product.rating} (${product.reviewCount} reviews)',
                          style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Price
                  Row(
                    children: [
                      Text(
                        '\$${discountedPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 8),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${product.discountPercent!.round()}% OFF',
                            style:
                                const TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Size selector (if available)
                  if (product.sizes.isNotEmpty) ...[
                    const Text('Size',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: product.sizes.map((size) => ChoiceChip(
                            label: Text(size),
                            selected: _selectedSize == size,
                            onSelected: (val) =>
                                setState(() => _selectedSize = val ? size : null),
                          )).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Color selector (if available)
                  if (product.colors.isNotEmpty) ...[
                    const Text('Color',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children: product.colors.map((color) => GestureDetector(
                            onTap: () =>
                                setState(() => _selectedColor = color),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _selectedColor == color
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  color,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade800),
                                ),
                              ),
                            ),
                          )).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Quantity
                  Row(
                    children: [
                      const Text('Quantity',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      IconButton(
                        onPressed: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('$_quantity',
                          style: const TextStyle(fontSize: 18)),
                      IconButton(
                        onPressed: () => setState(() => _quantity++),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Add to Cart & Buy Now
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // ✅ Single call with the correct quantity
                            context.read<CartBloc>().add(
                                  AddToCart(
                                    product.id,
                                    product.name,
                                    product.price,
                                    product.imageUrls.isNotEmpty
                                        ? product.imageUrls[0]
                                        : '',
                                    quantity: _quantity,
                                  ),
                                );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      '$_quantity x ${product.name} added to cart')),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text('Add to Cart'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // ✅ Add to cart then navigate to checkout (single call)
                            context.read<CartBloc>().add(
                                  AddToCart(
                                    product.id,
                                    product.name,
                                    product.price,
                                    product.imageUrls.isNotEmpty
                                        ? product.imageUrls[0]
                                        : '',
                                    quantity: _quantity,
                                  ),
                                );
                            Navigator.pushNamed(context, '/checkout');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Buy Now'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text('Description',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(product.description,
                      style: TextStyle(
                          color: Colors.grey.shade700, height: 1.5)),
                  const SizedBox(height: 20),

                  // Related Products
                  if (relatedProducts.isNotEmpty) ...[
                    Text('Related Products',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: relatedProducts.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (ctx, i) {
                          final related = relatedProducts[i];
                          return GestureDetector(
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailScreen(product: related),
                              ),
                            ),
                            child: Container(
                              width: 140,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Image.network(
                                      related.imageUrls.isNotEmpty
                                          ? related.imageUrls[0]
                                          : 'https://via.placeholder.com/150',
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(related.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12)),
                                        const SizedBox(height: 4),
                                        Text(
                                          '\$${related.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}