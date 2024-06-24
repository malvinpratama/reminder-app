import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../features/pages.dart';
import '../models/models.dart';
import '../services/services.dart';

class AppRoutes {
  static final GoRouter _router = GoRouter(
    initialLocation: HomePage.route,
    observers: [TalkerRouteObserver(LoggerService.talker)],
    routes: [
      GoRoute(
        name: HomePage.route,
        path: HomePage.route,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        name: CreateTimeReminderPage.route,
        path: CreateTimeReminderPage.route,
        builder: (context, state) {
          final reminder = state.extra as TimeRemindersModel?;
          return CreateTimeReminderPage(timeReminder: reminder,);
        },
      ),
    ],
  );

  static GoRouter get router => _router;
}
