import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'glint_effect.dart';

var frameSize = Vector2(666, 899);
var contentSize = Vector2(613, 669);



class PhotoBackFrame extends PositionComponent {
  late final RRect rrectFrame;
  late final Paint paintFrame;

  PhotoBackFrame() {
    size = frameSize;

    rrectFrame = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(20),
    );

    paintFrame = Paint()..color = const Color(0xFF_F4E9D6);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(rrectFrame, paintFrame);
  }
}

class PhotoFrontFrame extends PositionComponent {
  late final RRect rrectFrame;
  late final Paint paintFrame;
  late final RRect rrectHole;

  PhotoFrontFrame() {
    size = frameSize;

    rrectFrame = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(20),
    );

    // 挖空區域 - 照片內容區域
    rrectHole = RRect.fromRectAndRadius(
      Rect.fromLTWH(26, 31, contentSize.x, contentSize.y),
      const Radius.circular(24),
    );

    paintFrame = Paint()..color = const Color(0xFF_FFFFFF);
  }

  @override
  void render(Canvas canvas) {
    final path = Path()
      ..addRRect(rrectFrame)
      ..addRRect(rrectHole)
      ..fillType = PathFillType.evenOdd;
    
    canvas.drawPath(path, paintFrame);
  }
}

class PhotoContent extends PositionComponent {
  late final RRect rrectContent;
  late final Paint paintContent;

  PhotoContent() {
    size = contentSize;
    position = Vector2(26, 31);

    rrectContent = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(24),
    );

    paintContent = Paint()..color = const Color(0xFFF4E9D6);

    // 添加閃光效果
    add(GlintEffect(
      clipRect: rrectContent,
    ));
  }

  @override
  void render(Canvas canvas) {
    canvas.clipRRect(rrectContent);
  }
}

// frame 整個框框
// content 照片本身
class PhotoInstax extends PositionComponent {
  late final PhotoBackFrame photoBackFrame;
  late final PhotoFrontFrame photoFrontFrame;
  late final PhotoContent photoContent;
  late final SpriteComponent Function(Vector2 size) subjectBuilder;
  late final TextComponent title;
  late final SpriteComponent star1;
  late final SpriteComponent star2;
  late final SpriteComponent star3;

  PhotoInstax({required this.subjectBuilder}) {
    size = frameSize;
    photoBackFrame = PhotoBackFrame();
    photoFrontFrame = PhotoFrontFrame();
    photoContent = PhotoContent();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(photoBackFrame);
    final subject = subjectBuilder((photoContent.size - Vector2(50, 50)));
    subject.anchor = Anchor.center;
    subject.position = Vector2(photoContent.size.x / 2 + 26, photoContent.size.y / 2 + 31);
    
    add(subject);
    add(photoContent);
    add(photoFrontFrame);

    title = TextBoxComponent(
      text: "企鵝走走",
      textRenderer: TextPaint(
        style: typography.tp48,
      ),
      boxConfig: TextBoxConfig(
        maxWidth: 666,
      ),
      align: Anchor.center,
    );
    title.anchor = Anchor.topLeft;
    title.position = Vector2(0,735);
    add(title);

    // final starImage = await Flame.images.load(images.star);
    // star = SpriteComponent.fromImage(starImage);
    // star.anchor = Anchor.center;
    // star.position = Vector2(237, 735);
    // add(star);

    // 3 stars
    // 241,804 | 301,804 | 365,804
    final starImage = await Flame.images.load(images.star);
    star1 = SpriteComponent.fromImage(starImage);
    star1.anchor = Anchor.topLeft;
    star1.position = Vector2(241, 804);
    add(star1);

    star2 = SpriteComponent.fromImage(starImage);
    star2.anchor = Anchor.topLeft;
    star2.position = Vector2(301, 804);
    add(star2);

    star3 = SpriteComponent.fromImage(starImage);
    star3.anchor = Anchor.topLeft;
    star3.position = Vector2(365, 804);
    add(star3);
  }

  @override
  void onMount() {
    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    // clip on content
    super.render(canvas);
    canvas.clipRRect(photoFrontFrame.rrectFrame);
  }
}
