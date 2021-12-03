import 'package:flutter/material.dart';

import 'package:yummy/components/yummy_bottom_search_app_bar_widget.dart';

class CustomManagerAppBar extends StatefulWidget {
  const CustomManagerAppBar({
    Key key,
    @required this.manager,
    @required this.searchHintText,
    @required this.appBarTitle,
  }) : super(key: key);

  final dynamic manager;
  final String searchHintText;
  final Text appBarTitle;

  @override
  _CustomManagerAppBarState createState() => _CustomManagerAppBarState();
}

class _CustomManagerAppBarState extends State<CustomManagerAppBar> {
  bool onSearchActive = false;
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: onSearchActive
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                YummyBottomSearchAppBarWidget(
                  object: widget.manager,
                  focusNode: focusNode,
                  hintText: widget.searchHintText,
                  onClose: () {
                    setState(() {
                      onSearchActive = !onSearchActive;
                    });
                  },
                ),
              ],
            )
          : widget.appBarTitle,
      actions: onSearchActive == true
          ? [
              Container(),
            ]
          : [
              IconButton(
                icon: const Icon(
                  Icons.search,
                ),
                onPressed: () {
                  setState(() {
                    onSearchActive = !onSearchActive;
                    focusNode.requestFocus();
                  });
                },
              ),
            ],
    );
  }
}
