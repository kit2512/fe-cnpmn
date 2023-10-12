import 'package:fe_cnpmn/data/models/rfid_machine.dart';
import 'package:fe_cnpmn/pages/widgets/checkin_history_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RfidDetailsPage extends StatefulWidget {
  const RfidDetailsPage({
    super.key,
    required this.details,
  });

  static MaterialPageRoute<bool?> route({
    required RfidMachine details,
  }) =>
      MaterialPageRoute<bool?>(
        builder: (_) => RfidDetailsPage(
          details: details,
        ),
      );

  final RfidMachine details;

  @override
  State<RfidDetailsPage> createState() => _RfidDetailsPageState();
}

class _RfidDetailsPageState extends State<RfidDetailsPage> {
  @override
  void initState() {
    _rfidMachine = widget.details;
    super.initState();
  }

  late RfidMachine _rfidMachine;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(_rfidMachine.name),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16).copyWith(top: 24),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    child: Icon(
                      Icons.microwave_outlined,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Name: ',
                          ),
                          Text(
                            _rfidMachine.name,
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
                            _rfidMachine.id.toString(),
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
                            'Room: ',
                          ),
                          Text(
                            _rfidMachine.room!.name,
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
                            DateFormat('dd-MM-yyyy hh:mm:ss').format(_rfidMachine.dateCreated),
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
                        label: Text('Delete'),
                        icon: Icon(Icons.delete_rounded),
                      ),
                    ],
                  )
                ],
              ),
              Expanded(
                child: CheckinHistoryListView(
                  rfidId: _rfidMachine.id,
                ),
              ),
            ],
          ),
        ),
      );
}
