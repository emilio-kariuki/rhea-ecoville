import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ecoville/utilities/resources.dart';

void main() {
  test('icons assets test', () {
    expect(File(Icons.add).existsSync(), isTrue);
    expect(File(Icons.back).existsSync(), isTrue);
    expect(File(Icons.cart).existsSync(), isTrue);
    expect(File(Icons.clipboard).existsSync(), isTrue);
    expect(File(Icons.clock).existsSync(), isTrue);
    expect(File(Icons.close).existsSync(), isTrue);
    expect(File(Icons.favourite).existsSync(), isTrue);
    expect(File(Icons.favouriteSolid).existsSync(), isTrue);
    expect(File(Icons.flash).existsSync(), isTrue);
    expect(File(Icons.forward).existsSync(), isTrue);
    expect(File(Icons.github).existsSync(), isTrue);
    expect(File(Icons.google).existsSync(), isTrue);
    expect(File(Icons.happy).existsSync(), isTrue);
    expect(File(Icons.home).existsSync(), isTrue);
    expect(File(Icons.info).existsSync(), isTrue);
    expect(File(Icons.left).existsSync(), isTrue);
    expect(File(Icons.location).existsSync(), isTrue);
    expect(File(Icons.mail).existsSync(), isTrue);
    expect(File(Icons.menu).existsSync(), isTrue);
    expect(File(Icons.notifications).existsSync(), isTrue);
    expect(File(Icons.offer).existsSync(), isTrue);
    expect(File(Icons.phone).existsSync(), isTrue);
    expect(File(Icons.pin).existsSync(), isTrue);
    expect(File(Icons.profile).existsSync(), isTrue);
    expect(File(Icons.purchase).existsSync(), isTrue);
    expect(File(Icons.right).existsSync(), isTrue);
    expect(File(Icons.save).existsSync(), isTrue);
    expect(File(Icons.search).existsSync(), isTrue);
    expect(File(Icons.settings).existsSync(), isTrue);
    expect(File(Icons.share).existsSync(), isTrue);
    expect(File(Icons.smile).existsSync(), isTrue);
    expect(File(Icons.star).existsSync(), isTrue);
  });
}
