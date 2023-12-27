import 'package:entaj/src/modules/_main/tabs/account/logic.dart';

import 'app_config.dart';
import 'modules/_main/logic.dart';
import 'services/app_events.dart';
import 'package:get/get.dart';
import 'data/remote/api_requests.dart';
import 'data/shared_preferences/pref_manger.dart';
import 'modules/_main/tabs/home/logic.dart';
import 'modules/cart/logic.dart';
import 'modules/delivery_option/logic.dart';
import 'modules/pages/logic.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrefManger>(() => PrefManger());
    Get.lazyPut<ApiRequests>(() => ApiRequests());
    if (AppConfig.isEnglishLanguageEnable) {
      Get.lazyPut<ApiRequests>(() => ApiRequests(tag: 'ar'), tag: 'ar');
      Get.lazyPut<ApiRequests>(() => ApiRequests(tag: 'en'), tag: 'en');
    }
    Get.lazyPut<AppEvents>(() => AppEvents());
    Get.put<DeliveryOptionLogic>(
      DeliveryOptionLogic(),
      permanent: true,
    );
    Get.lazyPut<MainLogic>(() => MainLogic());
    Get.lazyPut<CartLogic>(() => CartLogic(), fenix: true);
    Get.lazyPut<PagesLogic>(() => PagesLogic());
    Get.lazyPut<HomeLogic>(() => HomeLogic());
    Get.put<AccountLogic>(
      AccountLogic(),
      permanent: true,
    );
  }
}
