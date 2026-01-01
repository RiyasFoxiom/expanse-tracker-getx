import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  MediaQueryData get device => MediaQuery.of(this);

  Size get deviceSize => MediaQuery.of(this).size;

  ThemeData get theme => Theme.of(this);
}
