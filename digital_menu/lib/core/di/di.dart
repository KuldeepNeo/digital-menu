import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../../features/menu/data/datasources/menu_remote_datasource.dart';
import '../../features/menu/data/repositories/menu_repository_impl.dart';
import '../../features/menu/domain/repositories/menu_repository.dart';
import '../../features/menu/domain/usecases/get_categories.dart';
import '../../features/menu/domain/usecases/get_dishes_by_category.dart';
import '../../features/menu/presentation/bloc/menu_cubit.dart';

import '../../features/admin/data/datasources/auth_remote_datasource.dart';
import '../../features/admin/data/repositories/auth_repository_impl.dart';
import '../../features/admin/domain/repositories/auth_repository.dart';
import '../../features/admin/domain/usecases/login_usecase.dart';
import '../../features/admin/domain/usecases/logout_usecase.dart';
import '../../features/admin/domain/usecases/stream_user_usecase.dart';
import '../../features/admin/presentation/controllers/auth_cubit.dart';

import '../../features/menu/domain/usecases/add_dish_usecase.dart';
import '../../features/menu/domain/usecases/upload_dish_image_usecase.dart';
import '../../features/menu/domain/usecases/update_dish_usecase.dart';
import '../../features/menu/domain/usecases/delete_dish_usecase.dart';
import '../../features/admin/presentation/controllers/admin_dish_cubit.dart';
import '../../features/menu/data/datasources/order_remote_datasource.dart';
import '../../features/menu/data/repositories/order_repository_impl.dart';
import '../../features/menu/domain/repositories/order_repository.dart';
import '../../features/menu/domain/usecases/submit_order_usecase.dart';
import '../../features/menu/presentation/bloc/cart_cubit.dart';
import '../../features/menu/domain/usecases/stream_orders_usecase.dart';
import '../../features/menu/domain/usecases/update_order_status_usecase.dart';
import '../../features/admin/presentation/controllers/kitchen_cubit.dart';

final sl = GetIt.instance;


Future<void> init() async {
  // External
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Data Sources
  sl.registerLazySingleton<MenuRemoteDataSource>(
    () => MenuRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetDishesByCategoryUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => StreamUserUseCase(sl()));
  sl.registerLazySingleton(() => AddDishUseCase(sl()));
  sl.registerLazySingleton(() => UploadDishImageUseCase(sl()));
  sl.registerLazySingleton(() => UpdateDishUseCase(sl()));
  sl.registerLazySingleton(() => DeleteDishUseCase(sl()));
  sl.registerLazySingleton(() => SubmitOrderUseCase(sl()));
  sl.registerLazySingleton(() => StreamOrdersUseCase(sl()));
  sl.registerLazySingleton(() => UpdateOrderStatusUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => MenuCubit(
      getCategoriesUseCase: sl(),
      getDishesByCategoryUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => AdminDishCubit(
      addDishUseCase: sl(),
      uploadDishImageUseCase: sl(),
      updateDishUseCase: sl(),
      deleteDishUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => CartCubit(
      submitOrderUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => KitchenCubit(
      streamOrdersUseCase: sl(),
      updateOrderStatusUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => AuthCubit(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      streamUserUseCase: sl(),
    ),
  );
}

