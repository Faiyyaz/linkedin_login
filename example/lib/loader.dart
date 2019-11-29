import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'dialog_utils.dart';

class Loader {
  final BuildContext context;
  final bool showBackgroundColor;

  Loader({@required this.context, @required this.showBackgroundColor});

  void show(Color color) {
    DialogUtils _dialogUtils = DialogUtils();
    _dialogUtils.showDialog(
      showBackgroundColor: showBackgroundColor,
      barrierDismissible: false,
      context: context,
      backgroundColor: Colors.black45,
      builder: (_) => SpinKitThreeBounce(
        color: color,
      ),
    );
  }

  void hide() {
    Navigator.pop(context);
  }
}
