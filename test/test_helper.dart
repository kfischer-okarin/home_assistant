import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

File createTempFile() {
  final file = File('${Directory.systemTemp.path}/${uuid.v4()}.json');

  addTearDown(() {
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  return file;
}
