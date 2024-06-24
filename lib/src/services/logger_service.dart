import 'package:talker_flutter/talker_flutter.dart';

class LoggerService {
  // For Not ReCreate
  static final _instance = LoggerService._internal();
  factory LoggerService() => _instance;
  LoggerService._internal();

  static Talker? _talker;

  static Talker get talker {
    _talker ??= TalkerFlutter.init();
    return _talker!;
  }
}
