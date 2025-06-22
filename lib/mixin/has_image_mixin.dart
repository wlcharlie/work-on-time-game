import 'dart:ui';

import 'package:flame/components.dart';

/// Mixin for SpriteComponent that requires an image getter
///
/// Classes using this mixin must implement:
/// - ui.Image get image
mixin HasImageMixin on SpriteComponent {
  /// Get the aspect ratio of the image (width / height)
  double getImageRatio() {
    return image.width / image.height;
  }

  /// The image that this component uses
  /// Must be implemented by classes using this mixin
  Image get image;
}
