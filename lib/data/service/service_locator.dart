import 'package:ecoville/data/local/local_database.dart';
import 'package:ecoville/data/provider/app_provider.dart';
import 'package:ecoville/data/provider/auth_provider.dart';
import 'package:ecoville/data/provider/bid_provider.dart';
import 'package:ecoville/data/provider/location_provider.dart';
import 'package:ecoville/data/provider/notification_provider.dart';
import 'package:ecoville/data/provider/product_provider.dart';
import 'package:ecoville/data/provider/user_provider.dart';
import 'package:ecoville/data/repository/app_repository.dart';
import 'package:ecoville/data/repository/auth_repository.dart';
import 'package:ecoville/data/repository/bid_repository.dart';
import 'package:ecoville/data/repository/location_repository.dart';
import 'package:ecoville/data/repository/notification_repository.dart';
import 'package:ecoville/data/repository/product_repository.dart';
import 'package:ecoville/data/repository/user_repository.dart';
import 'package:get_it/get_it.dart';

final service = GetIt.instance;

void initLocator() {
  service
    ..registerLazySingleton<AuthProvider>(
        () => AuthProvider(authRepository: service()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepository())
    ..registerLazySingleton<AppProvider>(
        () => AppProvider(appRepository: service()))
    ..registerLazySingleton<AppRepository>(() => AppRepository())
    ..registerLazySingleton<NotificationProvider>(
        () => NotificationProvider(notificationRepository: service()))
    ..registerLazySingleton<NotificationRepository>(
        () => NotificationRepository())
    ..registerLazySingleton<UserProvider>(
        () => UserProvider(userRepository: service()))
    ..registerLazySingleton<UserRepository>(() => UserRepository())
    ..registerLazySingleton<DatabaseHelper>(() => DatabaseHelper())
    ..registerLazySingleton<ProductProvider>(
        () => ProductProvider(productRepository: service()))
    ..registerLazySingleton<ProductRepository>(() => ProductRepository())
    ..registerLazySingleton<BidProvider>(
        () => BidProvider(bidRepository: service()))
    ..registerLazySingleton<BidRepository>(() => BidRepository())
    ..registerLazySingleton<LocationProvider>(
        () => LocationProvider(locationRepository: service()))
    ..registerLazySingleton<LocationRepository>(() => LocationRepository());
}
