import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import '../../models/models.dart';
import 'components/create_time_reminder_bloc.dart';

class CreateTimeReminderPage extends StatelessWidget {
  static const String route = '/time-reminder/create';
  const CreateTimeReminderPage({super.key, this.timeReminder});

  final TimeRemindersModel? timeReminder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlue,
        title: Text(
          "${timeReminder == null ? "Create" : "Edit"} Time Reminder",
          style: TextStyle(color: Colors.white, fontSize: 24.sp),
        ),
      ),
      body: BlocProvider<CreateTimeReminderBloc>(
        create: (context) => CreateTimeReminderBloc(timeReminder),
        child: BlocListener<CreateTimeReminderBloc, CreateTimeReminderState>(
          listener: (context, state) {
            final bloc = context.read<CreateTimeReminderBloc>();
            if (state.viewStatus == ViewStatus.success) {
              bloc.resetStatus();
              context.pop(true);
            }
          },
          child: Stack(
            children: [
              Padding(
                padding: REdgeInsets.all(16),
                child: Column(
                  children: [
                    buildFormReminder(),
                    128.verticalSpace,
                    BlocBuilder<CreateTimeReminderBloc,
                        CreateTimeReminderState>(
                      builder: (context, state) {
                        final bloc = context.read<CreateTimeReminderBloc>();
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.time == null
                                ? Colors.grey
                                : Colors.lightBlue,
                          ),
                          onPressed: () {
                            if (state.time != null &&
                                state.viewStatus == ViewStatus.idle) {
                              bloc.save();
                            }
                          },
                          child: Padding(
                            padding: REdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              BlocBuilder<CreateTimeReminderBloc, CreateTimeReminderState>(
                builder: (context, state) {
                  return state.viewStatus == ViewStatus.submitting
                      ? Material(
                          color: Colors.grey,
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  32.verticalSpace,
                                  const Text(
                                    "Saving...",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Column buildFormReminder() {
    return Column(
      children: [
        BlocBuilder<CreateTimeReminderBloc, CreateTimeReminderState>(
          buildWhen: (previous, current) {
            return previous.time != current.time;
          },
          builder: (context, state) {
            final bloc = context.read<CreateTimeReminderBloc>();
            return InkWell(
              onTap: () async {
                DateTime? dateTime = await showOmniDateTimePicker(
                  initialDate: state.time,
                  context: context,
                );
                if (dateTime != null) {
                  bloc.changeDateTime(dateTime);
                }
              },
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: REdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.lightBlue,
                        size: 24.sp,
                      ),
                      32.horizontalSpace,
                      Text(
                        state.time == null
                            ? "Choose Time"
                            : DateFormat("dd MMMM yyyy hh:mm a")
                                .format(state.time!),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        8.verticalSpace,
        BlocBuilder<CreateTimeReminderBloc, CreateTimeReminderState>(
            buildWhen: (previous, current) {
          return previous.title != current.title;
        }, builder: (context, state) {
          final bloc = context.read<CreateTimeReminderBloc>();
          return Card(
            color: Colors.white,
            child: Padding(
              padding: REdgeInsets.all(16),
              child: TextFormField(
                controller: bloc.titleController,
                style: TextStyle(fontSize: 24.sp),
                decoration: const InputDecoration(
                  enabledBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  label: Text(
                    "Title",
                  ),
                ),
                onChanged: bloc.changeTitle,
              ),
            ),
          );
        }),
        8.verticalSpace,
        BlocBuilder<CreateTimeReminderBloc, CreateTimeReminderState>(
            buildWhen: (previous, current) {
          return previous.description != current.description;
        }, builder: (context, state) {
          final bloc = context.read<CreateTimeReminderBloc>();
          return Card(
            color: Colors.white,
            child: Padding(
              padding: REdgeInsets.all(16),
              child: TextFormField(
                controller: bloc.descriptionController,
                style: TextStyle(fontSize: 24.sp),
                decoration: const InputDecoration(
                  enabledBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  label: Text(
                    "Description",
                  ),
                ),
                onChanged: bloc.changeDescription,
              ),
            ),
          );
        }),
        8.verticalSpace,
        BlocBuilder<CreateTimeReminderBloc, CreateTimeReminderState>(
            buildWhen: (previous, current) {
          return previous.note != current.note;
        }, builder: (context, state) {
          final bloc = context.read<CreateTimeReminderBloc>();
          return Card(
            color: Colors.white,
            child: Padding(
              padding: REdgeInsets.all(16),
              child: TextFormField(
                controller: bloc.noteController,
                style: TextStyle(fontSize: 24.sp),
                decoration: const InputDecoration(
                  enabledBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  label: Text(
                    "Note",
                  ),
                ),
                onChanged: bloc.changeNote,
              ),
            ),
          );
        }),
      ],
    );
  }
}
