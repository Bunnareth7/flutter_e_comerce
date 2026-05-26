import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../bloc/admin_product_bloc.dart';
import '../bloc/admin_product_event.dart';
import '../bloc/admin_product_state.dart';
import '../bloc/admin_order_bloc.dart';
import '../bloc/admin_order_event.dart';
import '../bloc/admin_order_state.dart';
import '../../../../features/product/domain/entities/product.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Guard – only allow admin email
    final authState = context.read<AuthBloc>().state;
    final userEmail = authState is Authenticated ? authState.user.email : null;
    if (userEmail != 'admin@eshop.com') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
      return const Scaffold(body: Center(child: Text('Access denied')));
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            // Title appears when the app bar is collapsed – no overlap with tabs
            title: const Text(
              'Admin Dashboard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              collapseMode: CollapseMode.parallax,
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'Products', icon: Icon(Icons.inventory_2)),
                Tab(text: 'Orders', icon: Icon(Icons.shopping_cart)),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildProductsTab(context),
            _buildOrdersTab(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }

  Widget _buildProductsTab(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdminProductBloc>()..add(LoadAdminProducts()),
      child: BlocBuilder<AdminProductBloc, AdminProductState>(
        builder: (context, state) {
          if (state is AdminProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminProductsLoaded) {
            if (state.products.isEmpty) {
              return const Center(child: Text('No products yet'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<AdminProductBloc>().add(LoadAdminProducts());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.imageUrls.isNotEmpty
                              ? product.imageUrls[0]
                              : 'https://via.placeholder.com/80',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 60),
                        ),
                      ),
                      title: Text(product.name,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('\$${product.price}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: Theme.of(context).colorScheme.primary),
                            onPressed: () =>
                                _showAddEditDialog(context, product: product),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Product'),
                                  content: Text(
                                      'Are you sure you want to delete "${product.name}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        context.read<AdminProductBloc>().add(
                                            DeleteAdminProduct(product.id));
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is AdminProductError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildOrdersTab(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminOrderBloc()..add(LoadAdminOrders()),
      child: BlocBuilder<AdminOrderBloc, AdminOrderState>(
        builder: (context, state) {
          if (state is AdminOrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminOrdersLoaded) {
            if (state.orders.isEmpty) {
              return const Center(child: Text('No orders yet'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                // Reload orders – simply re-add the event
                context.read<AdminOrderBloc>().add(LoadAdminOrders());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.receipt_long, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Order #${order.id.substring(0, 8)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: order.status == 'confirmed'
                                      ? Colors.green.shade50
                                      : Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  order.status.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: order.status == 'confirmed'
                                        ? Colors.green.shade700
                                        : Colors.orange.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Date: ${order.date.toString().substring(0, 16)}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          if (order.userEmail != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.person, size: 16),
                                  const SizedBox(width: 4),
                                  Text('Customer: ${order.userEmail}',
                                      style: TextStyle(
                                          color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                          const SizedBox(height: 8),
                          const Divider(),
                          ...order.items.map((item) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text(item.productName)),
                                    Text(
                                      '${item.quantity} × \$${item.price.toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              )),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                '\$${order.total.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is AdminOrderError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, {Product? product}) {
    final nameCtrl = TextEditingController(text: product?.name ?? '');
    final descCtrl = TextEditingController(text: product?.description ?? '');
    final priceCtrl =
        TextEditingController(text: product?.price.toString() ?? '');
    final imageUrlCtrl =
        TextEditingController(text: product?.imageUrls.join(', ') ?? '');
    final categoryCtrl =
        TextEditingController(text: product?.category ?? '');
    final stockCtrl =
        TextEditingController(text: product?.stockQuantity.toString() ?? '');
    final ratingCtrl =
        TextEditingController(text: product?.rating.toString() ?? '');
    final reviewCtrl =
        TextEditingController(text: product?.reviewCount.toString() ?? '');
    final discountCtrl =
        TextEditingController(text: product?.discountPercent?.toString() ?? '');
    final sizesCtrl =
        TextEditingController(text: product?.sizes.join(', ') ?? '');
    final colorsCtrl =
        TextEditingController(text: product?.colors.join(', ') ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(product == null ? 'Add Product' : 'Edit Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name')),
              TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Description')),
              TextField(
                  controller: priceCtrl,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: imageUrlCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Image URLs (comma separated)')),
              TextField(
                  controller: categoryCtrl,
                  decoration: const InputDecoration(labelText: 'Category')),
              TextField(
                  controller: stockCtrl,
                  decoration: const InputDecoration(labelText: 'Stock Quantity'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: ratingCtrl,
                  decoration: const InputDecoration(labelText: 'Rating'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: reviewCtrl,
                  decoration: const InputDecoration(labelText: 'Review Count'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: discountCtrl,
                  decoration: const InputDecoration(labelText: 'Discount %'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: sizesCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Sizes (comma separated)')),
              TextField(
                  controller: colorsCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Colors (comma separated)')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              final newProduct = Product(
                id: product?.id ??
                    DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameCtrl.text,
                description: descCtrl.text,
                price: double.tryParse(priceCtrl.text) ?? 0.0,
                imageUrls: imageUrlCtrl.text
                    .split(',')
                    .map((e) => e.trim())
                    .toList(),
                category: categoryCtrl.text,
                stockQuantity: int.tryParse(stockCtrl.text) ?? 0,
                rating: double.tryParse(ratingCtrl.text) ?? 0.0,
                reviewCount: int.tryParse(reviewCtrl.text) ?? 0,
                discountPercent: double.tryParse(discountCtrl.text),
                sizes: sizesCtrl.text.split(',').map((e) => e.trim()).toList(),
                colors: colorsCtrl.text.split(',').map((e) => e.trim()).toList(),
              );
              if (product == null) {
                context
                    .read<AdminProductBloc>()
                    .add(AddAdminProduct(newProduct));
              } else {
                context
                    .read<AdminProductBloc>()
                    .add(UpdateAdminProduct(newProduct));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}