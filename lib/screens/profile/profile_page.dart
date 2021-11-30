import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:yummy/screens/profile/components/graph_1.dart';
import 'package:yummy/utils/constants.dart';
import 'package:delayed_display/delayed_display.dart';

import '../../controllers/user/user_manager.dart';
import '../login/google_sign_in_screen.dart';
import 'components/graph_2.dart';
import 'components/graph_3.dart';
import 'components/image_profile_field.dart';

class SalesData {
  SalesData(this.month, this.sales);

  final String month;
  final int sales;
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(
      builder: (_, userManager, __) {
        if (!userManager.isLoggedIn) {
          return GoogleSignInScreen();
        } else if (userManager.loading) {
          return const CircularProgressIndicator();
        } else {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Perfil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (userManager.isLoggedIn) {
                      userManager.signOut();
                    } else {
                      Navigator.of(context).pushNamed('/login');
                    }
                  },
                  child: Text(
                    'Sair',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ],
            ),
            body: ListView(
              children: [
                const SizedBox(height: 32),
                DelayedDisplay(
                  delay: const Duration(milliseconds: 200),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ImageProfileField(),
                  ),
                ),
                const SizedBox(height: 20),
                DelayedDisplay(
                  delay: const Duration(milliseconds: 400),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      userManager.user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DelayedDisplay(
                  delay: const Duration(milliseconds: 600),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Graph1(),
                  ),
                ),
                DelayedDisplay(
                  delay: const Duration(milliseconds: 800),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Graph2(),
                  ),
                ),
                DelayedDisplay(
                  delay: const Duration(milliseconds: 1000),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Graph3(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
