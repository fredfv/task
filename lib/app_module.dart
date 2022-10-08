import 'package:flutter_modular/flutter_modular.dart';
import 'package:task/splash_page.dart';
import 'package:task/src/core/ui/wildcard_page.dart';
import 'package:task/src/modules/home/home_module.dart';

import 'src/core/services/http/http_service_dio_impl.dart';
import 'src/core/services/websocket/signalr_helper.dart';
import 'src/core/ui/services/forms_validade_impl.dart';
import 'src/modules/auth/auth_module.dart';
import 'src/modules/auth/repositories/login_repository_impl.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton((i) => LoginRepositoryImpl(i())),
        Bind.factory((i) => FormsValidateImpl()),
        Bind.lazySingleton((i) => HttpServiceDioImpl()),
        Bind.lazySingleton((i) => SignalRHelper())
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const SplashPage()),
        ModuleRoute('/src', module: AuthModule(), transition: TransitionType.size),
        ModuleRoute('/home', module: HomeModule(), transition: TransitionType.downToUp),
        WildcardRoute(
          child: (_, __) => const WildcardPage(),
        ) //RedirectRoute('/redir', to: '/auth/')
      ];
}
