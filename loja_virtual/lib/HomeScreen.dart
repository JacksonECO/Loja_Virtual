import 'package:flutter/material.dart';

import 'custom_drawer.dart';
import 'home_tab.dart';

class HomeScreen extends StatelessWidget {
  final _pagesController = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pagesController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pagesController),
        ),
      ],
    );
  }
}
