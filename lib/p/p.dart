import 'package:flutter/material.dart';

Scaffold p({
  Key? key,
  PreferredSizeWidget? appBar,
  Widget? body,
  Widget? floatingActionButton,
  FloatingActionButtonLocation? floatingActionButtonLocation,
  FloatingActionButtonAnimator? floatingActionButtonAnimator,
  List<Widget>? persistentFooterButtons,
  Widget? drawer,
  Widget? endDrawer,
  Color? backgroundColor,
  bool resizeToAvoidBottomInset = true,
}) {
  return Scaffold(
    key: key,
    appBar: appBar,
    body: body,
    floatingActionButton: floatingActionButton,
    floatingActionButtonLocation: floatingActionButtonLocation,
    floatingActionButtonAnimator: floatingActionButtonAnimator,
    persistentFooterButtons: persistentFooterButtons,
    drawer: drawer,
    endDrawer: endDrawer,
    backgroundColor: backgroundColor,
    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
  );
}