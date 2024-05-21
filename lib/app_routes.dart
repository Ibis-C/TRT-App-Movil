import 'package:flutter/material.dart';

import 'models/models.dart';
import 'screens/screens.dart';

class AppRoutes {
  // static const initialRoute = 'login';
  static const initialRoute = 'homePage';

  static final menuOptions = <MenuOptionModel>[
    MenuOptionModel(
      route: 'login',
      screen: const LoginScreen(),
    ),
    MenuOptionModel(
      route: 'homePage',
      screen: const HomePageScreen(),
    ),
    MenuOptionModel(
      route: 'addName',
      screen: const AddNameScreen(),
    ),
    MenuOptionModel(
      route: 'takeOrders',
      screen: const TakeOrdersScreen(),
    ),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    for (final option in menuOptions) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }

    return appRoutes;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const LoginScreen());
  }
}
