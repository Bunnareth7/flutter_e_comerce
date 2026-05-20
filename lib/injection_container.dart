import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


// Auth
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Product
import 'features/product/data/datasources/product_remote_data_source.dart';

import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/get_products.dart';
import 'features/product/domain/usecases/get_product_by_id.dart';
import 'features/product/presentation/bloc/product_bloc.dart';

// Cart
import 'features/cart/data/datasources/cart_local_data_source.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/repositories/cart_repository.dart';
import 'features/cart/domain/usecases/get_cart.dart';
import 'features/cart/domain/usecases/add_to_cart.dart';
import 'features/cart/domain/usecases/remove_from_cart.dart';
import 'features/cart/domain/usecases/update_cart_item_quantity.dart';
import 'features/cart/domain/usecases/clear_cart.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';

// Checkout
import 'features/checkout/data/datasources/checkout_remote_data_source.dart';
import 'features/checkout/data/repositories/checkout_repository_impl.dart';
import 'features/checkout/domain/repositories/checkout_repository.dart';
import 'features/checkout/domain/usecases/place_order.dart';
import 'features/checkout/presentation/bloc/checkout_bloc.dart';

// Order
import 'features/order/data/datasources/order_local_data_source.dart';
import 'features/order/data/repositories/order_repository_impl.dart';
import 'features/order/domain/repositories/order_repository.dart';
import 'features/order/domain/usecases/get_orders.dart';
import 'features/order/domain/usecases/save_order.dart';
import 'features/order/presentation/bloc/order_bloc.dart';

// Profile
import 'features/profile/data/datasources/profile_local_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_profile.dart';
import 'features/profile/domain/usecases/update_profile.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final dbPath = await getDatabasesPath();
  final database = await openDatabase(
    join(dbPath, 'eshop.db'),
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE users (
          id TEXT PRIMARY KEY,
          email TEXT UNIQUE,
          name TEXT,
          token TEXT,
          phone TEXT,
          address TEXT,
          avatarUrl TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE cart_items (
          productId TEXT PRIMARY KEY,
          productName TEXT,
          price REAL,
          imageUrl TEXT,
          quantity INTEGER
        )
      ''');
      await db.execute('''
        CREATE TABLE orders (
          id TEXT PRIMARY KEY,
          items TEXT,
          total REAL,
          date TEXT,
          status TEXT
        )
      ''');
    },
  );
  sl.registerLazySingleton<Database>(() => database);

  // Auth
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(database: sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerFactory(() => AuthBloc(loginUseCase: sl(), signUpUseCase: sl(), logoutUseCase: sl()));

  // Product
  sl.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl());
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductById(sl()));
  sl.registerFactory(() => ProductBloc(getProducts: sl(), getProductById: sl()));

  // Cart
  sl.registerLazySingleton<CartLocalDataSource>(() => CartLocalDataSourceImpl(database: sl()));
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton(() => GetCart(sl()));
  sl.registerLazySingleton(() => AddToCart(sl()));
  sl.registerLazySingleton(() => RemoveFromCart(sl()));
  sl.registerLazySingleton(() => UpdateCartItemQuantity(sl()));
  sl.registerLazySingleton(() => ClearCart(sl()));
  sl.registerFactory(() => CartBloc(
        getCart: sl(),
        addToCart: sl(),
        removeFromCart: sl(),
        updateQuantity: sl(),
        clearCart: sl(),
      ));

  // Checkout
  sl.registerLazySingleton<CheckoutRemoteDataSource>(() => CheckoutRemoteDataSourceImpl());
  sl.registerLazySingleton<CheckoutRepository>(() => CheckoutRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => PlaceOrder(sl()));

  // Order
  sl.registerLazySingleton<OrderLocalDataSource>(() => OrderLocalDataSourceImpl(database: sl()));
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton(() => GetOrders(sl()));
  sl.registerLazySingleton(() => SaveOrder(sl()));

  sl.registerFactory(() => CheckoutBloc(placeOrder: sl(), saveOrder: sl()));
  sl.registerFactory(() => OrderBloc(getOrders: sl()));

  // Profile
  sl.registerLazySingleton<ProfileLocalDataSource>(() => ProfileLocalDataSourceImpl(database: sl()));
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerFactory(() => ProfileBloc(getProfile: sl(), updateProfile: sl()));
}