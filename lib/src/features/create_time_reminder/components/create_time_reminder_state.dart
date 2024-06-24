part of 'create_time_reminder_bloc.dart';

class CreateTimeReminderState extends Equatable {
  final DateTime? time;
  final String? title;
  final String? description;
  final String? note;
  final ViewStatus viewStatus;

  const CreateTimeReminderState({
    this.time,
    this.title,
    this.description,
    this.note,
    this.viewStatus = ViewStatus.idle,
  });

  CreateTimeReminderState copyWith({
    DateTime? time,
    String? title,
    String? description,
    String? note,
    ViewStatus? viewStatus,
  }) {
    return CreateTimeReminderState(
      time: time ?? this.time,
      title: title ?? this.title,
      description: description ?? this.description,
      note: note ?? this.note,
      viewStatus: viewStatus ?? this.viewStatus,
    );
  }
  
  @override
  List<Object?> get props => [
    time,
    title,
    description,
    note,
    viewStatus,
  ];
}
