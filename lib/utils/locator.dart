import 'package:get_it/get_it.dart';
import 'package:reading_retention_tool/service/navigation_service.dart';

GetIt locator = GetIt.instance;

void setUpLocator(){
  locator.registerLazySingleton(() => NavigationService());
}