import 'package:get_it/get_it.dart';
import 'package:spendwise/services/connectivityService.dart';
import 'package:spendwise/services/firebaseService.dart';
import 'package:spendwise/services/sharedPreferencesService.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerSingleton<ConnectivityService>(ConnectivityService());
  locator.registerSingleton<FirebaseService>(FirebaseService());
  locator.registerSingleton<SharedPreferencesService>(
    SharedPreferencesService(),
  );
}
