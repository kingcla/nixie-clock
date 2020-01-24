import 'dart:math';

import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static bool _isPortrait;

  ///The Widith in of the screen in px.
  static double screenWidth;

  ///The Height of the screen in px.
  static double screenHeight;

  ///Relative block size for horizontal layout.
  static double blockSizeHorizontal;

  ///Relative block size for vertical layout.
  static double blockSizeVertical;

  ///Relative block size for horizontal layout. Including the safe zone.
  static double safeBlockHorizontal;

  ///Relative block size for vertical layout. Including the safe zone.
  static double safeBlockVertical;

  // Screen scaling ratio
  static double scaling;

  // Text scaling ratio
  static double textScaling;

  void init(BuildContext context, BoxConstraints constraints) {
    _mediaQueryData = MediaQuery.of(context);

    _isPortrait = _mediaQueryData.orientation == Orientation.portrait;

    scaling = _mediaQueryData.size.aspectRatio;
    textScaling = _mediaQueryData.textScaleFactor;

    screenWidth = min(_mediaQueryData.size.width, constraints.maxWidth);
    screenHeight = min(_mediaQueryData.size.height, constraints.maxHeight);

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
}
