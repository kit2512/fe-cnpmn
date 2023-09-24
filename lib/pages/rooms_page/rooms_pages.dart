import 'package:fe_cnpmn/dependency_injection.dart';
import 'package:fe_cnpmn/pages/employees_page/add_employees_dialog.dart';
import 'package:fe_cnpmn/pages/room_details/room_details_page.dart';
import 'package:fe_cnpmn/pages/rooms_page/cubit/rooms_cubit/rooms_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  static const String routeName = 'employees';

  MaterialPageRoute<void> route() => MaterialPageRoute(
    builder: (context) => const RoomsPage(),
  );

  @override
  Widget build(BuildContext context) => BlocProvider<RoomsCubit>.value(
    value: getIt<RoomsCubit>()..getRooms(),
    child: const _RoomsPageView(),
  );
}

class _RoomsPageView extends StatelessWidget {
  const _RoomsPageView();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Manage Employees'),
      actions: [
        TextButton.icon(
          onPressed: () => showDialog<bool?>(
            context: context,
            builder: (context) => const AddEmployeeDialog(),
          ).then((value) {
            if (value == true) {
              context.read<RoomsCubit>().getRooms();
            }
          }),
          icon: const Icon(
            Icons.add_rounded,
            color: Colors.white,
          ),
          label: const Text(
            'Add',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton.icon(
          onPressed: () => context.read<RoomsCubit>().getRooms(refresh: true),
          label: const Text(
            'Refresh',
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(
            Icons.refresh,
            color: Colors.white,
          ),
        )
      ],
    ),
    body: BlocBuilder<RoomsCubit, RoomsState>(
      builder: (context, state) {
        if (state.status.isFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Unable to get employees'),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  onPressed: context.read<RoomsCubit>().getRooms,
                  child: const Text('Refresh'),
                )
              ],
            ),
          );
        }
        if (state.status.isInProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.rooms.isEmpty) {
          return const Center(
            child: Text('No employee, please create one'),
          );
        }
        return SizedBox(
          width: double.infinity,
          child: DataTable(
            showCheckboxColumn: false,
            showBottomBorder: true,
            headingRowColor: MaterialStatePropertyAll<Color>(Colors.blue[200]!),
            columns: const [
              DataColumn(
                label: Text('ID'),
              ),
              DataColumn(
                label: Text('Name'),
              ),
              DataColumn(
                label: Text('Date created'),
              ),
            ],
            rows: state.rooms
                .map(
                  (room) => DataRow(
                onSelectChanged: (_) => Navigator.of(context).push(
                  RoomDetailsPage.route(
                    roomId: room.id,
                  ),
                ),
                cells: [
                  DataCell(
                    Text(room.id.toString()),
                  ),
                  DataCell(
                    Text(room.name.toString()),
                  ),
                  DataCell(
                    Text(
                      DateFormat('dd-MM-yyyy').format(
                        room.dateCreated,
                      ),
                    ),
                  ),
                ],
              ),
            )
                .toList(),
          ),
        );
      },
    ),
  );
}
