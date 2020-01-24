import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'components.dart';
import 'settings.dart';

/// Nixie Desk showing a beautiful clock built with Nixie Tubes and a wooden base
class NixieDesk extends StatefulWidget {
  /// Return a desk set with the specified [hour] in format HH or hh
  /// and [minute] in format mm
  NixieDesk(
      this.hour, this.minute, this.location, this.temperature, this.weather,
      {Key key})
      : super(key: key);

  final String hour, minute, location, temperature, weather;

  @override
  _NixieDeskState createState() => _NixieDeskState();
}

class _NixieDeskState extends State<NixieDesk> {
  // Digit that represent the state of the clock
  final NixieDigit digitHour1 = NixieDigit();
  final NixieDigit digitHour2 = NixieDigit();
  final NixieDigit digitMinute1 = NixieDigit();
  final NixieDigit digitMinute2 = NixieDigit();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Initialize the global size settings used to scale the widget
      // based on the parent constraints
      SizeConfig().init(context, constraints);

      // middle position for the dots for the enire base including paddings
      double middlePos = ((SizeConfig.blockSizeHorizontal * 100) / 2) -
          (SizeConfig.blockSizeHorizontal * 6);

      // Intenral positions for tubes, dots and base

      double lineTop = SizeConfig.blockSizeVertical * 15;
      double lineDots = SizeConfig.blockSizeVertical * 20;
      double lineFirst = SizeConfig.blockSizeHorizontal * 8;
      double lineSecond = SizeConfig.blockSizeHorizontal * 23;
      double lineBottom = SizeConfig.blockSizeVertical * 1;
      double lineTextBottom = SizeConfig.blockSizeVertical * 18;
      double lineTextLeft = SizeConfig.blockSizeHorizontal * 8;

      // Set Sizes of components

      // dots are a little smaller than tubes
      double dotsWidth = SizeConfig.blockSizeHorizontal * 5;
      double dotsHeight = SizeConfig.blockSizeVertical * 30;

      // The base takes 100% of the screen width and 45% of the screen height
      double baseWidth = SizeConfig.blockSizeHorizontal * 94;
      double baseHeight = SizeConfig.blockSizeVertical * 45;

      // A tube is scaled down for screen size
      double tubeWidth = SizeConfig.blockSizeHorizontal * 11;
      double tubeHeight = SizeConfig.blockSizeVertical * 35;

      double textSize = 25 * SizeConfig.textScaling;

      double iconWidth = SizeConfig.blockSizeHorizontal * 10;
      double iconHeight = SizeConfig.blockSizeVertical * 10;

      // Get the single digits values

      int hour1 = int.parse(widget.hour.substring(0, 1));
      int hour2 = int.parse(widget.hour.substring(1, 2));
      int minute1 = int.parse(widget.minute.substring(0, 1));
      int minute2 = int.parse(widget.minute.substring(1, 2));

      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
            bottom: SizeConfig.blockSizeVertical * 10,
            left: SizeConfig.blockSizeHorizontal * 3,
            right: SizeConfig.blockSizeHorizontal * 3),
        child: Stack(
          fit: StackFit.loose,
          children: <Widget>[
            Positioned(
                bottom: lineBottom,
                child: WoodClockBase(baseWidth, baseHeight)),
            Positioned(
                top: lineTop,
                left: lineFirst,
                child: digitHour1.getTubeDigit(hour1, tubeWidth, tubeHeight)),
            Positioned(
                top: lineTop,
                left: lineSecond,
                child: digitHour2.getTubeDigit(hour2, tubeWidth, tubeHeight)),
            Positioned(
                top: lineDots,
                left: middlePos,
                child: NixieDots(dotsWidth, dotsHeight)),
            Positioned(
                top: lineTop,
                right: lineSecond,
                child:
                    digitMinute1.getTubeDigit(minute1, tubeWidth, tubeHeight)),
            Positioned(
                top: lineTop,
                right: lineFirst,
                child:
                    digitMinute2.getTubeDigit(minute2, tubeWidth, tubeHeight)),
            Positioned(
              bottom: lineTextBottom,
              left: lineTextLeft,
              child: NeonText(widget.location, textSize),
            ),
            Positioned(
              bottom: lineTextBottom - 40,
              left: lineTextLeft + 40,
              child: NeonText('${widget.temperature}', textSize),
            ),
            Positioned(
              bottom: lineTextBottom - 35,
              left: lineTextLeft,
              child: WeatherIcon(widget.weather, 25, iconWidth, iconHeight),
            )
          ],
        ),
      );
    });
  }
}

class WeatherIcon extends StatelessWidget {
  const WeatherIcon(this.weatherCondition, this.size, this.width, this.height,
      {Key key})
      : super(key: key);

  final String weatherCondition;
  final double size, width, height;

  @override
  Widget build(BuildContext context) {
    /*
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
        children: <Widget>[
          Positioned(
            left: 1.0,
            top: 2.0,
            child: Icon(icon, color: const Color(0xFFFF8142), size: size),
          ),
          Icon(icon, color: const Color(0xFFFFBE50), size: size),
        ],
      ),
    );
  }
}

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
        // or styly
        // or parisianne
        style: GoogleFonts.yellowtail(
          textStyle: TextStyle(
            fontSize: size,
            color: const Color(0xFFFFBE50),
            shadows: [
              Shadow(
                blurRadius: 5.0,
                color: const Color(0xFFFF8142),
                offset: const Offset(5.0, 2.0),
              ),
            ],
          ),
        ));
  }
}
