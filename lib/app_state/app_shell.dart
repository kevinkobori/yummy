import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:yummy/utils/constants.dart';
import '../app_state/router/app_state.dart';
import '../app_state/router/inner_router_delegate.dart';

class AppShell extends StatefulWidget {
  final YummyAppState appState;

  const AppShell({
    @required this.appState,
  });

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  InnerRouterDelegate _routerDelegate;
  ChildBackButtonDispatcher _backButtonDispatcher;

  @override
  void initState() {
    super.initState();
    _routerDelegate = InnerRouterDelegate(widget.appState);

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _routerDelegate.appState = widget.appState;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _backButtonDispatcher = Router.of(context)
        .backButtonDispatcher
        .createChildBackButtonDispatcher();
  }

  // void showNotification(String title, String message) {
  //   Flushbar(
  //     title: title,
  //     message: message,
  //     flushbarPosition: FlushbarPosition.TOP,
  //     flushbarStyle: FlushbarStyle.GROUNDED,
  //     isDismissible: true,
  //     backgroundColor: Theme.of(context).accentColor,
  //     duration: const Duration(seconds: 10),
  //     icon: SvgPicture.asset(
  //       'assets/icons/cart_icon.svg',
  //       semanticsLabel: 'Listas',
  //       height: 20,
  //       color: Theme.of(context).canvasColor,
  //     ),
  //   ).show(context);
  // }

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;

    _backButtonDispatcher.takePriority();

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Router(
            routerDelegate: _routerDelegate,
            backButtonDispatcher: _backButtonDispatcher,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.azulMuitoClaro,
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.rosaClaro,
          unselectedItemColor: AppColors.azulClaro,
          currentIndex: appState.selectedIndex.toInt(),
          onTap: (newIndex) {
            appState.selectedIndex = newIndex.toDouble();
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Encontrar",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list_rounded),
              label: "Listas",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: "Receitas",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
