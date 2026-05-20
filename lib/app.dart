import 'package:e_com_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:e_com_app/features/order/presentation/bloc/order_bloc.dart';
import 'package:e_com_app/features/order/presentation/screen/order_history_screen.dart';
import 'package:e_com_app/features/profile/presentation/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/product/presentation/screens/product_list_screen.dart';
import 'features/cart/presentation/screens/cart_screen.dart';
//import 'features/order/presentation/screens/order_history_screen.dart';
//import 'features/profile/presentation/screens/profile_screen.dart';

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()..add(CheckAuthStatus())),
        BlocProvider<CartBloc>(create: (_) => sl<CartBloc>()),
        BlocProvider<OrderBloc>(create: (_) => sl<OrderBloc>()),
      ],
      child: MaterialApp(
        title: 'E-Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return const MainScreen();
            }
            return  LoginScreen();
          },
        ),
        routes: {
          '/main': (_) =>  MainScreen(),
          '/login': (_) => LoginScreen(),
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
    CartScreen(),
    OrderHistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}