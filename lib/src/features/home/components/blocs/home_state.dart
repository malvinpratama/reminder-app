part of 'home_bloc.dart';

class HomeState extends Equatable {
  final int index;
  final List<TimeRemindersModel> timeReminders;

  const HomeState({
    this.index = 0,
    this.timeReminders = const <TimeRemindersModel>[],
  });

  HomeState copyWith({
    int? index,
    List<TimeRemindersModel>? timeReminders,
  }) {
    return HomeState(
      index: index ?? this.index,
      timeReminders: timeReminders ?? this.timeReminders,
    );
  }

  @override
  List<Object?> get props => [
        index,
        timeReminders,
      ];
}
