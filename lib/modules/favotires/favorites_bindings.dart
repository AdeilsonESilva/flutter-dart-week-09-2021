import 'package:app_filmes/modules/favotires/favorites_controller.dart';
import 'package:get/get.dart';

class FavoritesBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(FavoritesController(
        authService: Get.find(), moviesService: Get.find()));
  }
}
