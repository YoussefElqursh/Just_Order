import 'package:get_it/get_it.dart';
import 'package:just_order/core/services/notification_service.dart';
import 'package:just_order/core/storage/storage_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core / Services
  getIt.registerSingleton<StorageService>(StorageService.instance);
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  
  // Repositories
  
  // Cubits / ViewModels
}
