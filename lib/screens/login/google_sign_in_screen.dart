import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:provider/provider.dart';
import 'package:yummy/components/login_custom_shape.dart';
import 'package:yummy/utils/constants.dart';

import '../../controllers/user/user_manager.dart';

class GoogleSignInScreen extends StatefulWidget {
  @override
  _GoogleSignInScreenState createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen>
    with TickerProviderStateMixin {
  GifController controller;
  @override
  void initState() {
    super.initState();
    controller = GifController(vsync: this);
    controller.repeat(min: 0, max: 200, period: const Duration(seconds: 6));
    Future.delayed(const Duration(seconds: 5)).then((value) => controller
        .repeat(min: 130, max: 160, period: const Duration(seconds: 1)));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userManager = Provider.of<UserManager>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),
                Image.asset(
                  'assets/logos/full-logo.png',
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                const Spacer(),
                Image.asset(
                  'assets/logos/cooker.jpeg',
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 4),
                        blurRadius: 5.0,
                      )
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.0, 0.4, 1.0],
                      colors: [
                        Colors.blue[200],
                        Colors.blue[300],
                        Colors.blue[400],
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () async {
                      await userManager.signIn(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logos/google-paint-logo.png',
                            height: 32,
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Entrar com o Google',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
