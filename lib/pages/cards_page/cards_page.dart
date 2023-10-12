import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:fe_cnpmn/data/models/card.dart';
import 'package:fe_cnpmn/data/models/employee.dart';
import 'package:fe_cnpmn/data/repositories/card_repository.dart';
import 'package:fe_cnpmn/dependency_injection.dart';
import 'package:fe_cnpmn/helpers/exception_helper.dart';
import 'package:fe_cnpmn/pages/widgets/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) => const _CardsView();
}

class _CardsView extends StatefulWidget {
  const _CardsView({super.key});

  @override
  State<_CardsView> createState() => _CardsViewState();
}

class _CardsViewState extends State<_CardsView> {
  @override
  void initState() {
    _getCards();
    super.initState();
  }

  FormzSubmissionStatus _cardListStatus = FormzSubmissionStatus.initial;

  late List<RfidCard> _cards;

  final CardRepository cardRepository = getIt<CardRepository>();

  Future<void> _getCards() async {
    final failureOrResponse = await cardRepository.getCards();
    failureOrResponse.fold(
      (l) => setState(
        () {
          _cardListStatus = FormzSubmissionStatus.failure;
        },
      ),
      (r) => setState(
        () {
          _cardListStatus = FormzSubmissionStatus.success;
          _cards = r;
        },
      ),
    );
  }

  void _deleteCard(RfidCard card) async {
    final result = await showDialog<bool?>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete card'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Are you sure you want to delete this card?'),
                  if (card.employeeId != null) Text('This card is assigned to employee ${card.employeeId}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final failureOrResponse = await cardRepository.deleteCard(cardId: card.id);
                    failureOrResponse.fold(
                      (l) {
                        Flushbar<void>(
                          message: getErrorMessage(l),
                          duration: const Duration(seconds: 3),
                        ).show(context);
                      },
                      (r) {
                        Navigator.of(context).pop(true);
                      },
                    );
                  },
                  child: const Text('Delete'),
                ),
              ],
            ));
    if (result == true) {
      unawaited(
        Flushbar<void>(
          message: 'Card deleted successfully',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ).show(context),
      );
      unawaited(_getCards());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Manage cards'),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                showDialog<bool?>(context: context, builder: (context) => const AddCardDialog()).then((result) {
                  if (result == true) {
                    Flushbar<void>(
                      message: 'Card added successfully',
                      duration: const Duration(seconds: 3),
                    ).show(context);
                    _getCards();
                  }
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
            ElevatedButton.icon(
              onPressed: _getCards,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Refresh'),
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            if (_cardListStatus.isFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Unable to get cards, please try gain'),
                    ElevatedButton(onPressed: _getCards, child: const Text('Refresh'))
                  ],
                ),
              );
            }
            if (_cardListStatus.isSuccess) {
              if (_cards.isEmpty) {
                return const Center(
                  child: Text('No cards'),
                );
              }
              return SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const [
                      DataColumn(
                        label: Text('ID'),
                      ),
                      DataColumn(
                        label: Text('Date created'),
                      ),
                      DataColumn(
                        label: Text('Employee ID'),
                      ),
                      DataColumn(label: Text('Actions'))
                    ],
                    rows: _cards
                        .map(
                          (card) => DataRow(
                            cells: [
                              DataCell(Text(card.id.toString())),
                              DataCell(Text(card.dateCreated.toString())),
                              DataCell(Text((card.employeeId ?? 'Not assigned').toString())),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.delete_rounded),
                                  onPressed: () => _deleteCard(card),
                                ),
                              )
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          },
        ),
      );
}

class AddCardDialog extends StatefulWidget {
  const AddCardDialog({super.key});

  @override
  State<AddCardDialog> createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<AddCardDialog> {
  Employee? _selectedEmployee;
  String _cardId = '';

  FormzSubmissionStatus _status = FormzSubmissionStatus.initial;

  final CardRepository cardRepository = getIt<CardRepository>();

  Future<void> _addCard() async {
    setState(() {
      _status = FormzSubmissionStatus.inProgress;
    });
    final failureOrResponse = await cardRepository.addCard(
      cardId: _cardId,
      employeeId: _selectedEmployee?.id,
    );
    failureOrResponse.fold(
      (l) {
        setState(() {
          _status = FormzSubmissionStatus.failure;
        });
        Flushbar<void>(
          message: getErrorMessage(l),
          duration: const Duration(seconds: 3),
        ).show(context);
      },
      (r) {
        setState(() {
          _status = FormzSubmissionStatus.success;
        });

        Navigator.of(context).pop(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Add Card'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Card ID',
              ),
              onChanged: (value) {
                setState(() {
                  _cardId = value;
                });
              },
            ),
            const SizedBox(height: 8),
            const Text('Choose an employee'),
            EmployeeListView(
              selectable: true,
              onSelect: (employee) {
                setState(() {
                  _selectedEmployee = employee;
                });
              },
              showDateCreated: false,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _status.isInProgress || _cardId.isEmpty ? null : _addCard,
            child: _status.isInProgress ? const CircularProgressIndicator.adaptive() : const Text('Add'),
          ),
        ],
      );
}
