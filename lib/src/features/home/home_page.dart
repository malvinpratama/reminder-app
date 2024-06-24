import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../repositories/time_reminder_repository.dart';
import '../../services/services.dart';
import '../pages.dart';
import 'components/blocs/home_bloc.dart';
import 'components/widgets/time_reminder_list.dart';

class HomePage extends StatelessWidget {
  static const String route = '/home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<TimeReminderRepository>(
      create: (context) => TimeReminderRepository(DatabaseService.database),
      child: BlocProvider<HomeBloc>(
        create: (context) => HomeBloc(context.read<TimeReminderRepository>()),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {},
          builder: (context, state) {
            final bloc = context.read<HomeBloc>();
            return DefaultTabController(
              length: 2,
              initialIndex: state.index,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.lightBlue,
                  centerTitle: true,
                  title: Text(
                    state.index == 0 ? "Based on Time" : "Based on Location",
                    style: TextStyle(color: Colors.white, fontSize: 24.sp),
                  ),
                  bottom: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Colors.orange,
                    tabs: [
                      Tab(
                        icon: Icon(
                          Icons.watch_later_outlined,
                          color:
                              state.index == 0 ? Colors.white : Colors.blueGrey,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.location_on_outlined,
                          color:
                              state.index == 1 ? Colors.white : Colors.blueGrey,
                        ),
                      ),
                    ],
                    onTap: (value) {
                      bloc.changeIndex(value);
                    },
                  ),
                ),
                body: const TabBarView(
                  children: [
                    TimeReminderList(),
                    SizedBox(),
                  ],
                ),
                floatingActionButton:
                    state.index != 0 || state.timeReminders.isEmpty
                        ? null
                        : FloatingActionButton.extended(
                            onPressed: () {
                              context.pushNamed(CreateTimeReminderPage.route).then((_) {
                                bloc.getNextReminder();
                              },);
                            },
                            label: const Icon(Icons.add),
                          ),
              ),
            );
          },
        ),
      ),
    );
  }
}
