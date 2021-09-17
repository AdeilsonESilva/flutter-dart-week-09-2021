import 'package:get/get.dart';

import 'package:app_filmes/application/ui/loader/loader_mixin.dart';
import 'package:app_filmes/application/ui/messages/messages_mixin.dart';
import 'package:app_filmes/services/login/login_service.dart';

class LoginController extends GetxController with LoaderMixin, MessagesMixin {
  // var nome = 'Adeilson'.obs;
  // var nome = RxString('Adeilson');
  // var nome = Rx<String>('Adeilson');

  final LoginService _loginService;
  final loading = false.obs;
  final message = Rxn<MessageModel>();

  LoginController({
    required LoginService loginService,
  }) : _loginService = loginService;

  @override
  void onInit() {
    super.onInit();
    loaderListener(loading);
    messageListener(message);
  }

  Future<void> login() async {
    // loading(true); // callable class
    // await Future.delayed(const Duration(seconds: 2));
    // await 2.seconds.delay();
    // loading(false);
    // message(MessageModel.error(title: 'title', message: 'message'));
    // await 1.seconds.delay();
    // message(MessageModel.info(title: 'title', message: 'message'));

    try {
      loading(true);
      await _loginService.login();
      loading(false);
      message(MessageModel.info(
          title: 'Sucesso', message: 'Login realizado com sucesso'));
    } catch (e) {
      // } catch (e, s) {
      // print(e);
      // print(s);
      loading(false);
      message(
          MessageModel.error(title: 'Erro', message: 'Erro ao realizar login'));
    }
  }
}
