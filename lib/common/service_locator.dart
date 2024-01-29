
import 'package:enaam/common/apicalls.dart';
import 'package:enaam/common/enaam_json_parser.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future setup() async {
  locator.registerSingleton<EnaamJsonParser>(EnaamJsonParser());
  locator.registerSingleton<ApiCalls>(ApiCalls());
  var jsonLocator = GetIt.instance<EnaamJsonParser>();
  await jsonLocator.init();
  /*await jsonLocator.readJson();
  await jsonLocator.readHomePage();
  await jsonLocator.readNotificationPage();
  await jsonLocator.readTicketsPage();
  await jsonLocator.readDrawsPage();
  await jsonLocator.readProductsPage();*/
}
