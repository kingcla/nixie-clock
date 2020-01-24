import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// Some constant values

const FRONT_COLOR = const Color(0xFFFFBE50);
const SHADOW_COLOR = const Color(0xFFFF8142);

const BOX_ASSET_FILENAME = "assets/box.flr";
const DOTS_ASSET_FILENAME = "assets/dots.flr";
const TUBE_ASSET_FILENAME = "assets/tube.flr";

const DOTS_ANIMATION_NAME = 'DOTS LOOP';

/**
 * Support class to manage each digit.
 * This class will hold an istance of the Tube widget for each digit.
 * When created we will only play the ON animation.
 * When set to a different digit, we will play the OFF animation of the current digit, 
 * followed by the ON animation of the new digit.
 * This will ensure a smoot transition between the digits in the tube.
 * 
 * This class will aslo hold the size of the tube widget at any time. 
 * If the size is changed, eg. rotating the screen, the tube will be re-created with the specified value.
 * 
 * For this purpose we use Unique keys to draw the widgets.
 * Unique keys will ensure that different instances of [NixiTube] widget are drawn indipendently.
 */
class NixieDigit {
  NixieDigit() {
    _currentValue = -1;
  }

  int _currentValue;
  Widget _tube;
  double _width, _height;

  /// Return the [NixiTube] widget matching the specifi digit [value].
  /// The widget will be diplayed with the passed [width] and [height].
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

/// The base widget to hold the tubes
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
        BOX_ASSET_FILENAME,
        fit: BoxFit.fill, // expand to fit the container fully
        alignment: Alignment.center,
        shouldClip: false,
      ),
    );
  }
}

/// The tube widget diplaying blinking dots every second
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
        DOTS_ASSET_FILENAME,
        fit: BoxFit.fill, // expand to fit the container fully
        alignment: Alignment.center,
        animation: DOTS_ANIMATION_NAME,
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
        TUBE_ASSET_FILENAME,
        fit: BoxFit.fill, // expand to fit the container fully
        alignment: Alignment.center,
        animation: isStarted ? widget.initialAnimation : widget.nextAnimation,
        shouldClip: false,
        callback: playNextAnimation,
      ),
    );
  }

  void playNextAnimation(String s) {
    // Once the first animation has completed, set isStarted to false
    // so that the next animation, if any, will play

    setState(() {
      isStarted = false;
    });
  }
}

/// Draw an icon based on the weather condition string passed by the model
class WeatherIcon extends StatelessWidget {
  const WeatherIcon(this.weatherCondition, this.size, this.width, this.height,
      {Key key})
      : super(key: key);

  final String weatherCondition;
  final double size, width, height;

  @override
  Widget build(BuildContext context) {
    /*
    From model enumeration
      cloudy,
      foggy,
      rainy,
      snowy,
      sunny,
      thunderstorm,
      windy,
    */

    IconData icon;
    switch (weatherCondition) {
      case 'sunny':
        icon = FontAwesomeIcons.sun;
        break;
      case 'foggy':
        icon = FontAwesomeIcons.smog;
        break;
      case 'rainy':
        icon = FontAwesomeIcons.cloudRain;
        break;
      case 'snowy':
        icon = FontAwesomeIcons.snowflake;
        break;
      case 'thunderstorm':
        icon = FontAwesomeIcons.bolt;
        break;
      case 'windy':
        icon = FontAwesomeIcons.wind;
        break;
      case 'cloudy':
        icon = FontAwesomeIcons.cloud;
        break;
      default:
        {
          return NeonText(weatherCondition, size);
        }
    }

    return Container(
      height: height,
      width: width,
      child: Stack(
        // this is a workaround to cast a shadow for this icon
        children: <Widget>[
          Positioned(
            left: 1.0,
            top: 2.0,
            child: Icon(icon, color: SHADOW_COLOR, size: size),
          ),
          Icon(icon, color: FRONT_COLOR, size: size),
        ],
      ),
    );
  }
}

/// Draw some [text] with a neon-like style
class NeonText extends StatelessWidget {
  const NeonText(this.text, this.size, {Key key}) : super(key: key);

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.fade,
        style: GoogleFonts.yellowtail(
          textStyle: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w400, // Regular
            color: FRONT_COLOR,
            shadows: [
              Shadow(
                blurRadius: 5.0,
                color: SHADOW_COLOR,
                offset: const Offset(5.0, 2.0),
              ),
            ],
          ),
        ));
  }
}
