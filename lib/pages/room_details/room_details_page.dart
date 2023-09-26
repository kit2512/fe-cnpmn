import 'package:fe_cnpmn/data/models/room.dart';
import 'package:fe_cnpmn/data/repositories/rooms_repository.dart';
import 'package:fe_cnpmn/dependency_injection.dart';
import 'package:fe_cnpmn/pages/room_details/cubit/room_details_cubit/room_details_cubit.dart';
import 'package:fe_cnpmn/pages/widgets/checkin_history_list.dart';
import 'package:fe_cnpmn/pages/widgets/employee_list.dart';
import 'package:fe_cnpmn/pages/widgets/rfid_machine_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RoomDetailsPage extends StatelessWidget {
  const RoomDetailsPage({
    super.key,
  });

  static MaterialPageRoute<void> route({
    required Room details,
  }) =>
      MaterialPageRoute(
        builder: (context) => BlocProvider<RoomDetailsCubit>(
          create: (context) => RoomDetailsCubit(
            details: details,
            roomRepository: getIt<RoomRepository>(),
          ),
          child: const RoomDetailsPage(),
        ),
      );

  @override
  Widget build(BuildContext context) => const _RoomDetailsPageView();
}

class _RoomDetailsPageView extends StatelessWidget {
  const _RoomDetailsPageView({super.key});

  @override
  Widget build(BuildContext context) => BlocConsumer<RoomDetailsCubit, RoomDetailsState>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text('Room: ${state.room!.name}'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      child: Icon(
                        Icons.meeting_room_rounded,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Name: ',
                            ),
                            Text(
                              state.room!.name,
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
                              'ID: ',
                            ),
                            Text(
                              state.room!.id.toString(),
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
                              DateFormat('dd-MM-yyyy hh:mm:ss').format(state.room!.dateCreated),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {},
                          label: const Text('Delete'),
                          icon: const Icon(
                            Icons.delete_rounded,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TabBar(
                          isScrollable: true,
                          unselectedLabelColor: Colors.grey,
                          labelColor: Colors.blue,
                          tabs: [
                            Tab(
                              text: 'Checkin history',
                            ),
                            Tab(
                              text: 'Allowed employees',
                            ),
                            Tab(
                              text: 'RFID machines',
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              CheckinHistoryListView(
                                showRoomId: false,
                                roomId: state.room!.id,
                              ),
                              EmployeeListView(
                                roomId: state.room!.id,
                              ),
                              RfidMachineListView(
                                roomId: state.room!.id,
                                showRoomId: false,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
