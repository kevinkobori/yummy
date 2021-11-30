import 'package:flutter/material.dart';
import 'package:yummy/utils/constants.dart';

class YummyAppBarWidget extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  const YummyAppBarWidget({
    Key key,
    @required this.title,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.branco.withOpacity(0.8),
      elevation: 0,
      toolbarHeight: 38,
      actions: actions,
      titleSpacing: 0,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
