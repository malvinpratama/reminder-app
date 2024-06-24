import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/database/time_reminders_model.dart';
import '../../../../repositories/repository.dart';
import '../../../../services/services.dart';
part 'home_state.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc(TimeReminderRepository timeReminderRepository)
      : _timeReminderRepository = timeReminderRepository,
        super(const HomeState()) {
    init();
  }

  final TimeReminderRepository _timeReminderRepository;

  changeIndex(int index) {
    emit(
      state.copyWith(
        index: index,
      ),
    );
  }

  init() {
    getNextReminder();
  }

  getNextReminder() async {
    final result = await _timeReminderRepository.getNextReminder();
    emit(
      state.copyWith(
        timeReminders: result,
      ),
    );
  }

 Future<void> deleteReminder(TimeRemindersModel reminder) async {
    final database = await DatabaseService.database;
    reminder.delete(database).then(
      (value) {
        if (value.isSuccess) {
          getNextReminder();
        }
      },
    );
  }
}
