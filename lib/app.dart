import 'package:e_com_app/features/address/presentation/bloc/address_bloc.dart';
import 'package:e_com_app/features/admin/presentation/bloc/admin_product_bloc.dart';
import 'package:e_com_app/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:e_com_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:e_com_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:e_com_app/features/cart/presentation/bloc/cart_state.dart';
import 'package:e_com_app/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:e_com_app/features/checkout/presentation/screens/onboarding_screen.dart';

import 'package:e_com_app/features/order/presentation/bloc/order_bloc.dart';
import 'package:e_com_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:e_com_app/features/review/presentation/bloc/review_bloc.dart';

import 'package:e_com_app/features/search/presentation/bloc/search_history_bloc.dart.dart';

import 'package:e_com_app/features/splash/presentation/splash_screen.dart';
import 'package:e_com_app/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:e_com_app/features/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:e_com_app/features/wishlist/presentation/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/product/presentation/screens/product_list_screen.dart';
import 'features/cart/presentation/screens/cart_screen.dart';
import 'features/order/presentation/screens/order_history_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(CheckAuthStatus()),
        ),
        BlocProvider<CartBloc>(create: (_) => sl<CartBloc>()..add(LoadCart())),
        BlocProvider<ProductBloc>(create: (_) => sl<ProductBloc>()),
        BlocProvider<OrderBloc>(create: (_) => sl<OrderBloc>()),
        BlocProvider<AddressBloc>(create: (_) => sl<AddressBloc>()),
        BlocProvider<ReviewBloc>(create: (_) => sl<ReviewBloc>()),
        BlocProvider<AdminProductBloc>(create: (_) => sl<AdminProductBloc>()),
        BlocProvider<SearchHistoryBloc>(create: (_) => sl<SearchHistoryBloc>()),
        BlocProvider<WishlistBloc>(
            create: (_) => sl<WishlistBloc>()..add(LoadWishlist())),
      ],
      child: MaterialApp(
        title: 'E-Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6C63FF),
            brightness: Brightness.light,
          ),
          fontFamily: 'Poppins',
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.all(20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        // Show splash screen first, then route to appropriate screen
        home: const SplashScreen(),
        routes: {
          '/home': (_) => BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is Authenticated) {
                    return const MainScreen();
                  }
                  return const LoginScreen();
                },
              ),
          '/main': (_) => const MainScreen(),
          '/login': (_) => const LoginScreen(),
          '/checkout': (_) => const CheckoutScreen(),
          '/onboarding': (_) => const OnboardingScreen(),
          '/admin': (_) => const AdminDashboardScreen(),   // one single route for the admin dashboard
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ProductListScreen(),
    WishlistScreen(),
    CartScreen(),
    OrderHistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          int itemCount = 0;
          if (state is CartLoaded) {
            itemCount = state.totalItems;
          }
          return BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: 'Wishlist',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart_outlined),
                    if (itemCount > 0)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$itemCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Cart',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                label: 'Orders',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}