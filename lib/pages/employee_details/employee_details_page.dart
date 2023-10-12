import 'package:fe_cnpmn/data/repositories/employee_repository.dart';
import 'package:fe_cnpmn/dependency_injection.dart';
import 'package:fe_cnpmn/pages/employee_details/blocs/employee_details_bloc/employee_details_cubit.dart';
import 'package:fe_cnpmn/pages/employee_details/rooms_view.dart';
import 'package:fe_cnpmn/pages/employees_page/cubit/employees_cubit.dart';
import 'package:fe_cnpmn/pages/widgets/checkin_history_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

class EmployeeDetailsPage extends StatelessWidget {
  const EmployeeDetailsPage({super.key});

  static MaterialPageRoute<void> route({
    required int id,
  }) =>
      MaterialPageRoute(
        builder: (context) => BlocProvider<EmployeeDetailsCubit>(
          create: (context) => EmployeeDetailsCubit(
            employeeRepository: getIt<EmployeeRepository>(),
          )..getDetails(id),
          child: const EmployeeDetailsPage(),
        ),
      );

  @override
  Widget build(BuildContext context) => BlocConsumer<EmployeeDetailsCubit, EmployeeDetailsState>(
        listenWhen: (prev, current) => current.detailsStatus != prev.deleteStatus,
        listener: (context, state) {
          if (state.deleteStatus.isSuccess) {
            getIt<EmployeesCubit>().getEmployees(refresh: true);
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) => Scaffold(
          appBar: state.detailsStatus.isInProgress
              ? null
              : AppBar(
                  title: Text('Employee: ${state.details?.user.fullName ?? ''}'),
                ),
          body: state.detailsStatus.isInProgress
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : state.detailsStatus.isFailure
                  ? Center(
                      child: Column(
                        children: [
                          const Text(
                            'Unable to get employee details, please try again',
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          ElevatedButton(
                            onPressed: () => context.read<EmployeeDetailsCubit>().getDetails(state.id!),
                            child: const Text('Refresh'),
                          ),
                        ],
                      ),
                    )
                  : const _EmployeeDetailsView(),
        ),
      );
}

class _EmployeeDetailsView extends StatelessWidget {
  const _EmployeeDetailsView();

  @override
  Widget build(BuildContext context) => BlocBuilder<EmployeeDetailsCubit, EmployeeDetailsState>(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(16).copyWith(top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'ID: ',
                          ),
                          Text(
                            state.details!.id.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Card ID: ',
                          ),
                          Text(
                            state.details!.card?.id ?? 'No card assigned',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8,),
                          InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.blue,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const Text(
                            'First name: ',
                          ),
                          Text(
                            state.details!.user.firstName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Last name: ',
                          ),
                          Text(
                            state.details!.user.lastName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Username: ',
                          ),
                          Text(
                            state.details!.user.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Date created: ',
                          ),
                          Text(
                            DateFormat('dd-MM-yyyy').format(
                              state.details!.user.dateCreated,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    onPressed: () {
                      showDialog<bool?>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm delete'),
                          content: const Text('Are you sure you want to delete this employee?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            )
                          ],
                        ),
                      ).then(
                        (value) {
                          if (value == true) {
                            context.read<EmployeeDetailsCubit>().deleteEmployee();
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TabBar(
                        isScrollable: true,
                        tabs: [
                          Tab(
                            text: 'Checkin history',
                          ),
                          Tab(
                            text: 'Allowed rooms',
                          ),
                        ],
                        unselectedLabelColor: Colors.grey,
                        labelColor: Colors.blue,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            CheckinHistoryListView(
                              employeeId: state.id,
                              showEmployeeId: false,
                              showCardId: false,
                            ),
                            RoomsView(
                              employeeId: state.id!,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
