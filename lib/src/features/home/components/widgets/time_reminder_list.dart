import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../models/models.dart';
import '../../../pages.dart';
import '../blocs/home_bloc.dart';

class TimeReminderList extends StatelessWidget {
  const TimeReminderList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        final bloc = context.read<HomeBloc>();
        if (state.timeReminders.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                ),
                onPressed: () {
                  context.pushNamed(CreateTimeReminderPage.route).then(
                    (_) {
                      bloc.getNextReminder();
                    },
                  );
                },
                child: Padding(
                  padding: REdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: const Text(
                    "Create Reminder",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          );
        }
        return Column(
          children: [
            16.verticalSpace,
            Expanded(
              child: ListView.separated(
                itemCount: state.timeReminders.length,
                separatorBuilder: (context, index) => 8.verticalSpace,
                itemBuilder: (context, index) {
                  final reminder = state.timeReminders[index];

                  return buildCardReminder(reminder, bloc);
                },
              ),
            ),
            16.verticalSpace,
          ],
        );
      },
    );
  }

  Card buildCardReminder(TimeRemindersModel reminder, HomeBloc bloc) {
    return Card(
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                context
                    .pushNamed(CreateTimeReminderPage.route, extra: reminder)
                    .then(
                  (_) {
                    bloc.getNextReminder();
                  },
                );
              },
              backgroundColor: Colors.lightBlue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (context) {
                showAdaptiveDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog.adaptive(
                      title: const Text("Are you sure delete this reminder ?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: const Text(
                            "No",
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            bloc.deleteReminder(reminder).then(
                              (_) {
                                context.pop();
                              },
                            );
                          },
                          child: const Text(
                            "Yes",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Padding(
          padding: REdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  DateFormat("dd MMMM yyyy hh:mm").format(
                      DateTime.fromMillisecondsSinceEpoch(reminder.time)),
                  style:
                      TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              Padding(
                padding: REdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title ?? "-",
                      style: TextStyle(fontSize: 24.sp),
                    ),
                    Text(
                      reminder.description ?? "-",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    if (reminder.note != null)
                      Column(
                        children: [
                          8.verticalSpace,
                          Text(
                            "notes : ${reminder.note}",
                            style:
                                TextStyle(fontSize: 12.sp, color: Colors.grey),
                          ),
                        ],
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
