import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/widgets.dart';

class NixieDigit {
  NixieDigit() {
    _currentValue = -1;
  }

  int _currentValue;
  Widget _tube;
  double _width, _height;

  Widget getTubeDigit(int value, double width, double height) {
    if (width != _width || height != _height) {
      // the size of the tube has been adjusted,
      // we need to force the redrawing at the next call

      _currentValue = -1;
    }

    _width = width;
    _height = height;

    if (_currentValue == -1) {
      // just starting, only fade-in the new digit
      _tube = NixiTube('#$value ON', '', _width, _height, key: UniqueKey());
    } else if (_currentValue != value) {
      // fade-out first the old current digit, then fade-in the new one
      // only play the transition animations if the digit has hanged
      // here we need to pass a unique key because the state can be different for different nixie widgets
      _tube = NixiTube('#$_currentValue OFF', '#$value ON', _width, _height,
          key: UniqueKey());
    }

    // set the curretn value
    _currentValue = value;

    return _tube;
  }
}

class WoodClockBase extends StatelessWidget {
  const WoodClockBase(
    this.width,
    this.height, {
    Key key,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: FlareActor(
        "assets/box.flr",
        fit: BoxFit.fill, // expand to fit the container fully
        alignment: Alignment.center,
        shouldClip: false,
      ),
    );
  }
}

class NixieDots extends StatefulWidget {
  const NixieDots(this.width, this.height, {Key key}) : super(key: key);
  final double width;
  final double height;

  @override
  _NixieDotsState createState() => _NixieDotsState();
}

class _NixieDotsState extends State<NixieDots> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: FlareActor(
        "assets/dots.flr",
        fit: BoxFit.fill, // expand to fit the container fully
        alignment: Alignment.center,
        animation: 'DOTS LOOP',
        shouldClip: false,
      ),
    );
  }
}

/// A Nixie Clock Tube Widget
class NixiTube extends StatefulWidget {
  /// Create a new widget specifing the [initialAnimation] and [nextAnimation]
  const NixiTube(
      this.initialAnimation, this.nextAnimation, this.width, this.height,
      {Key key})
      : super(key: key);

  final String initialAnimation, nextAnimation;
  final double width, height;

  @override
  _NixiTubeState createState() => _NixiTubeState();
}

class _NixiTubeState extends State<NixiTube> {
  bool isStarted = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: FlareActor(
        "assets/tube.flr",
        fit: BoxFit.fill, // expand to fit the container fully
        alignment: Alignment.center,
        animation: isStarted ? widget.initialAnimation : widget.nextAnimation,
        shouldClip: false,
        callback: playNextAnimation,
      ),
    );
  }

  void playNextAnimation(String s) {
    setState(() {
      isStarted = false;
    });
  }
}
