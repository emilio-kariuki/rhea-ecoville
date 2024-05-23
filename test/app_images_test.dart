import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ecoville/utilities/resources.dart';

void main() {
  test('app_images assets test', () {
    expect(File(app_images.add).existsSync(), isTrue);
    expect(File(app_images.back).existsSync(), isTrue);
    expect(File(app_images.cart).existsSync(), isTrue);
    expect(File(app_images.clipboard).existsSync(), isTrue);
    expect(File(app_images.clock).existsSync(), isTrue);
    expect(File(app_images.close).existsSync(), isTrue);
    expect(File(app_images.favourite).existsSync(), isTrue);
    expect(File(app_images.favouriteSolid).existsSync(), isTrue);
    expect(File(app_images.flash).existsSync(), isTrue);
    expect(File(app_images.forward).existsSync(), isTrue);
    expect(File(app_images.github).existsSync(), isTrue);
    expect(File(app_images.google).existsSync(), isTrue);
    expect(File(app_images.happy).existsSync(), isTrue);
    expect(File(app_images.home).existsSync(), isTrue);
    expect(File(app_images.info).existsSync(), isTrue);
    expect(File(app_images.left).existsSync(), isTrue);
    expect(File(app_images.location).existsSync(), isTrue);
    expect(File(app_images.mail).existsSync(), isTrue);
    expect(File(app_images.menu).existsSync(), isTrue);
    expect(File(app_images.notifications).existsSync(), isTrue);
    expect(File(app_images.offer).existsSync(), isTrue);
    expect(File(app_images.phone).existsSync(), isTrue);
    expect(File(app_images.pin).existsSync(), isTrue);
    expect(File(app_images.profile).existsSync(), isTrue);
    expect(File(app_images.purchase).existsSync(), isTrue);
    expect(File(app_images.right).existsSync(), isTrue);
    expect(File(app_images.save).existsSync(), isTrue);
    expect(File(app_images.search).existsSync(), isTrue);
    expect(File(app_images.settings).existsSync(), isTrue);
    expect(File(app_images.share).existsSync(), isTrue);
    expect(File(app_images.smile).existsSync(), isTrue);
    expect(File(app_images.star).existsSync(), isTrue);
  });
}
