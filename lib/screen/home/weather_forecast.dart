import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart' show Canvas;
import 'package:work_on_time_game/config/enums.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/wot_game.dart';

class WeatherForecast extends PositionComponent
    with HasGameReference<WOTGame>, TapCallbacks, HasPaint {
  late RectangleComponent _bg;
  late SpriteComponent _character;
  late SpriteComponent _weather;
  late Dialog _dialog;

  late WeatherType _weatherType;
  late String _weatherDescription;

  final void Function() onTap;

  WeatherForecast({required this.onTap});

  @override
  void onLoad() {
    super.onLoad();

    _weatherType =
        WeatherType.values[Random().nextInt(WeatherType.values.length)];

    size = game.size;
    // should follow the camera?
    position = game.camera.viewfinder.position;
    print(position);
    _bg = RectangleComponent(
      size: game.size,
      paint: Paint()..color = const Color(0xFFDAECE1),
    );
    final host = game.images.fromCache(images.weatherForecastHost);
    final hostSprite = Sprite(host);
    _character = SpriteComponent(
      sprite: hostSprite,
      position: Vector2(12, 405),
    );

    final weatherImagePath = switch (_weatherType) {
      WeatherType.sunny => images.weatherForecastSunny,
      WeatherType.cloudy => images.weatherForecastCloudy,
      WeatherType.rainy => images.weatherForecastRain,
    };

    _weatherDescription = switch (_weatherType) {
      WeatherType.sunny => '今天會是晴朗的好天氣！',
      WeatherType.cloudy => '今天會是陰陰的，出門記得帶傘',
      WeatherType.rainy => '今天會下雨，記得帶傘出門',
    };

    final weather = game.images.fromCache(weatherImagePath);
    final weatherSprite = Sprite(weather);
    _weather = SpriteComponent(
      sprite: weatherSprite,
      position: Vector2(game.size.x / 2, 380),
      anchor: Anchor.center,
      scale: Vector2(0, 0),
    );

    _dialog = Dialog(onTap: () {}, weatherDescription: _weatherDescription);

    _bg.makeTransparent();
    // _weather.makeTransparent();
    _character.makeTransparent();

    add(_bg);
    add(_weather);
    add(_character);
    _bg.add(
      OpacityEffect.to(
        1,
        EffectController(duration: 0.8),
      ),
    );
    _weather.add(SequenceEffect(
      [
        OpacityEffect.to(
          1,
          EffectController(duration: 0.4, startDelay: 1.6),
          onComplete: () {
            add(_dialog);
          },
        ),
        ScaleEffect.to(
          Vector2(1, 1),
          EffectController(duration: 0.4),
        ),
      ],
    ));
    _character.add(
      OpacityEffect.to(
        1,
        EffectController(duration: 0.8, startDelay: 0.8),
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    removeFromParent();

    onTap();
  }
}

class Dialog extends PositionComponent with HasGameReference<WOTGame> {
  final String weatherDescription;
  Dialog({required this.onTap, required this.weatherDescription});

  final void Function() onTap;

  @override
  void onLoad() {
    super.onLoad();
    size = Vector2(345, 68);
    position = Vector2(24, 755);
    anchor = Anchor.topLeft;

    // text
    final text = TextBoxComponent(
      text: weatherDescription,
      textRenderer: TextPaint(
        style: typography.tp20,
      ),
      align: Anchor.center,
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
      boxConfig: TextBoxConfig(
        timePerChar: 0.05,
      ),
      size: size,
    );
    add(text);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // bgfill
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        Radius.circular(10),
      ),
      Paint()
        ..color =
            ColorExtension.fromRGBHexString("#FFFFFF").withValues(alpha: 0.8),
    );

    // border
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        Radius.circular(10),
      ),
      Paint()
        ..color = ColorExtension.fromRGBHexString("#887768")
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }
}
