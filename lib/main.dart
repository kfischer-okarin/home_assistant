import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:home_assistant/app.dart';
import 'package:home_assistant/domain/home_assistant_service.dart';
import 'package:home_assistant/infra/local_json_file_event_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final documentsDirectory = await getApplicationDocumentsDirectory();
  final eventRepository = LocalJSONFileEventRepository(
      File('${documentsDirectory.path}/events.json'));
  final service = HomeAssistantService(eventRepository);
  runApp(App(service));
}
