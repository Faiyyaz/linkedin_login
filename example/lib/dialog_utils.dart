import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DialogUtils {
  Future<T> showDialog<T>({
    @required
        BuildContext context,
    Color backgroundColor,
    bool barrierDismissible = true,
    @Deprecated(
        'Instead of using the "child" argument, return the child from a closure '
        'provided to the "builder" argument. This will ensure that the BuildContext '
        'is appropriate for widgets built in the dialog.')
        Widget child,
    WidgetBuilder builder,
    bool showBackgroundColor,
  }) {
    assert(child == null || builder == null);
    assert(debugCheckHasMaterialLocalizations(context));

    if (showBackgroundColor) {
      backgroundColor = backgroundColor;
    } else {
      backgroundColor = null;
    }

    final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
    return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = child ?? Builder(builder: builder);
        return SafeArea(
          child: Builder(builder: (BuildContext context) {
            return theme != null
                ? Theme(data: theme, child: pageChild)
                : pageChild;
          }),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: backgroundColor,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildMaterialDialogTransitions,
    );
  }

  Future<T> showWithoutSafeAreaDialog<T>({
    @required
        BuildContext context,
    Color backgroundColor,
    bool barrierDismissible = true,
    @Deprecated(
        'Instead of using the "child" argument, return the child from a closure '
        'provided to the "builder" argument. This will ensure that the BuildContext '
        'is appropriate for widgets built in the dialog.')
        Widget child,
    WidgetBuilder builder,
    bool showBackgroundColor,
  }) {
    assert(child == null || builder == null);
    assert(debugCheckHasMaterialLocalizations(context));

    if (showBackgroundColor) {
      backgroundColor = backgroundColor;
    } else {
      backgroundColor = null;
    }

    final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
    return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = child ?? Builder(builder: builder);
        return Builder(builder: (BuildContext context) {
          return theme != null
              ? Theme(data: theme, child: pageChild)
              : pageChild;
        });
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: backgroundColor,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildMaterialDialogTransitions,
    );
  }

  Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }
}
