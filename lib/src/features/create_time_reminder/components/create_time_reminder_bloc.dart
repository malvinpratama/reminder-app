import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../models/models.dart';
import '../../../services/services.dart';
part 'create_time_reminder_state.dart';

class CreateTimeReminderBloc extends Cubit<CreateTimeReminderState> {
  CreateTimeReminderBloc(this.reminder)
      : super(const CreateTimeReminderState()) {
    init();
  }

  final TimeRemindersModel? reminder;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final noteController = TextEditingController();

  init() {
    if (reminder != null) {
      titleController.text = reminder!.title ?? '';
      descriptionController.text = reminder!.description ?? '';
      noteController.text = reminder!.note ?? '';
      emit(
        state.copyWith(
          time: DateTime.fromMillisecondsSinceEpoch(reminder!.time),
        ),
      );
    }
  }

  changeDateTime(DateTime value) {
    emit(
      state.copyWith(
        time: value,
      ),
    );
  }

  changeTitle(String value) {
    emit(
      state.copyWith(
        title: value,
      ),
    );
  }

  changeDescription(String value) {
    emit(
      state.copyWith(
        description: value,
      ),
    );
  }

  changeNote(String value) {
    emit(
      state.copyWith(
        note: value,
      ),
    );
  }

  save() async {
    emit(
      state.copyWith(
        viewStatus: ViewStatus.submitting,
      ),
    );
    final database = await DatabaseService.database;

    final status = await Permission.scheduleExactAlarm.status;
    if (!status.isGranted) {
      await Permission.scheduleExactAlarm.request().then(
        (value) {
          if (value == PermissionStatus.granted) {
            return;
          } else {
            emit(
              state.copyWith(
                viewStatus: ViewStatus.failure,
              ),
            );
          }
        },
      );
    }
    if (reminder == null) {
      final timeReminder = TimeRemindersModel(
        time: state.time!.millisecondsSinceEpoch,
        title: state.title,
        description: state.description,
        note: state.note,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      timeReminder.save(database).then(
        (result) {
          Future.delayed(
            const Duration(milliseconds: 300),
          ).then(
            (_) {
              if (result.isSuccess) {
                emit(
                  state.copyWith(
                    viewStatus: ViewStatus.success,
                  ),
                );
              } else {
                emit(
                  state.copyWith(
                    viewStatus: ViewStatus.failure,
                  ),
                );
              }
            },
          );
        },
      );
    } else {
      final timeReminder = TimeRemindersModel(
        id: reminder!.id,
        time: state.time!.millisecondsSinceEpoch,
        title: state.title,
        description: state.description,
        note: state.note,
        createdAt: reminder!.createdAt,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      timeReminder.update(database).then(
        (result) {
          Future.delayed(
            const Duration(milliseconds: 300),
          ).then(
            (_) {
              if (result.isSuccess) {
                emit(
                  state.copyWith(
                    viewStatus: ViewStatus.success,
                  ),
                );
              } else {
                emit(
                  state.copyWith(
                    viewStatus: ViewStatus.failure,
                  ),
                );
              }
            },
          );
        },
      );
    }
  }

  resetStatus() {
    emit(
      state.copyWith(
        viewStatus: ViewStatus.idle,
      ),
    );
  }
}
