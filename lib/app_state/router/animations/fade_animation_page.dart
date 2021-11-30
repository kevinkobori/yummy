import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FadeAnimationPage extends Page {
  final Widget child;
  const FadeAnimationPage({LocalKey key, this.child}) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) => child,
    );
  }
}
