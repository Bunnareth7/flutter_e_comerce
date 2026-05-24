//import 'package:e_com_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'features/auth/domain/usecases/reset_password_usecase.dart';

// Wishlist
import 'features/wishlist/data/datasources/wishlist_local_data_source.dart';
import 'features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'features/wishlist/domain/repositories/wishlist_repository.dart';
import 'features/wishlist/domain/usecases/get_wishlist.dart';
import 'features/wishlist/domain/usecases/add_to_wishlist.dart';
import 'features/wishlist/domain/usecases/remove_from_wishlist.dart';
import 'features/wishlist/domain/usecases/check_wishlist.dart';
import 'features/wishlist/presentation/bloc/wishlist_bloc.dart';

// Auth
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source_firebase.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Product
import 'features/product/data/datasources/product_remote_data_source_firestore.dart';
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

// Address
import 'features/address/data/datasources/address_local_data_source.dart';
import 'features/address/data/repositories/address_repository_impl.dart';
import 'features/address/domain/repositories/address_repository.dart';
import 'features/address/domain/usecases/get_addresses.dart';
import 'features/address/domain/usecases/add_address.dart';
import 'features/address/domain/usecases/update_address.dart';
import 'features/address/domain/usecases/delete_address.dart';
import 'features/address/domain/usecases/set_default_address.dart';
import 'features/address/presentation/bloc/address_bloc.dart';

// Reviews
import 'features/review/data/datasources/review_local_data_source.dart';
import 'features/review/data/repositories/review_repository_impl.dart';
import 'features/review/domain/repositories/review_repository.dart';
import 'features/review/domain/usecases/get_reviews.dart';
import 'features/review/domain/usecases/add_review.dart';
import 'features/review/presentation/bloc/review_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final dbPath = await getDatabasesPath();
  final database = await openDatabase(
    join(dbPath, 'eshop.db'),
    version: 3,   // ← bumped to 3
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
      await db.execute('''
        CREATE TABLE wishlist_items (
          productId TEXT PRIMARY KEY,
          productName TEXT,
          price REAL,
          imageUrl TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE addresses (
          id TEXT PRIMARY KEY,
          fullName TEXT,
          phone TEXT,
          street TEXT,
          city TEXT,
          state TEXT,
          zip TEXT,
          isDefault INTEGER DEFAULT 0
        )
      ''');
      await db.execute('''
        CREATE TABLE reviews (
          id TEXT PRIMARY KEY,
          productId TEXT NOT NULL,
          userName TEXT NOT NULL,
          rating REAL NOT NULL,
          comment TEXT,
          date TEXT NOT NULL
        )
      ''');
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('''
          CREATE TABLE addresses (
            id TEXT PRIMARY KEY,
            fullName TEXT,
            phone TEXT,
            street TEXT,
            city TEXT,
            state TEXT,
            zip TEXT,
            isDefault INTEGER DEFAULT 0
          )
        ''');
      }
      if (oldVersion < 3) {
        await db.execute('''
          CREATE TABLE reviews (
            id TEXT PRIMARY KEY,
            productId TEXT NOT NULL,
            userName TEXT NOT NULL,
            rating REAL NOT NULL,
            comment TEXT,
            date TEXT NOT NULL
          )
        ''');
      }
    },
  );
  sl.registerLazySingleton<Database>(() => database);

  // Auth
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(database: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceFirebase(),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      signUpUseCase: sl(),
      logoutUseCase: sl(),
      resetPasswordUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));

  // Product
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceFirestore(),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductById(sl()));
  sl.registerFactory(
    () => ProductBloc(getProducts: sl(), getProductById: sl()),
  );

  // Cart
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(database: sl()),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetCart(sl()));
  sl.registerLazySingleton(() => AddToCart(sl()));
  sl.registerLazySingleton(() => RemoveFromCart(sl()));
  sl.registerLazySingleton(() => UpdateCartItemQuantity(sl()));
  sl.registerLazySingleton(() => ClearCart(sl()));
  sl.registerFactory(
    () => CartBloc(
      getCart: sl(),
      addToCart: sl(),
      removeFromCart: sl(),
      updateQuantity: sl(),
      clearCart: sl(),
    ),
  );

  // Checkout
  sl.registerLazySingleton<CheckoutRemoteDataSource>(
    () => CheckoutRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => PlaceOrder(sl()));

  // Order
  sl.registerLazySingleton<OrderLocalDataSource>(
    () => OrderLocalDataSourceImpl(database: sl()),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetOrders(sl()));
  sl.registerLazySingleton(() => SaveOrder(sl()));

  sl.registerFactory(() => CheckoutBloc(placeOrder: sl(), saveOrder: sl()));
  sl.registerFactory(() => OrderBloc(getOrders: sl()));

  // Profile
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(database: sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerFactory(() => ProfileBloc(getProfile: sl(), updateProfile: sl()));

  // Wishlist
  sl.registerLazySingleton<WishlistLocalDataSource>(
    () => WishlistLocalDataSourceImpl(database: sl()),
  );
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetWishlist(sl()));
  sl.registerLazySingleton(() => AddToWishlist(sl()));
  sl.registerLazySingleton(() => RemoveFromWishlist(sl()));
  sl.registerLazySingleton(() => CheckWishlist(sl()));
  sl.registerFactory(
    () => WishlistBloc(
      getWishlist: sl(),
      addToWishlist: sl(),
      removeFromWishlist: sl(),
      checkWishlist: sl(),
    ),
  );

  // Address
  sl.registerLazySingleton<AddressLocalDataSource>(
      () => AddressLocalDataSourceImpl(database: sl()));
  sl.registerLazySingleton<AddressRepository>(
      () => AddressRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton(() => GetAddresses(sl()));
  sl.registerLazySingleton(() => AddAddress(sl()));
  sl.registerLazySingleton(() => UpdateAddress(sl()));
  sl.registerLazySingleton(() => DeleteAddress(sl()));
  sl.registerLazySingleton(() => SetDefaultAddress(sl()));
  sl.registerFactory(() => AddressBloc(
        getAddresses: sl(),
        addAddress: sl(),
        updateAddress: sl(),
        deleteAddress: sl(),
        setDefaultAddress: sl(),
      ));

  // Reviews
  sl.registerLazySingleton<ReviewLocalDataSource>(
      () => ReviewLocalDataSourceImpl(database: sl()));
  sl.registerLazySingleton<ReviewRepository>(
      () => ReviewRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton(() => GetReviews(sl()));
  sl.registerLazySingleton(() => AddReview(sl()));
  sl.registerFactory(
      () => ReviewBloc(getReviews: sl(), addReview: sl()));
}