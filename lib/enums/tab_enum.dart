import 'package:flutter/material.dart';

enum TabEnum {
  employees,
  rfidMachine,
  rooms,
}

extension TabEnumExtension on TabEnum {
  String get translationName {
    switch (this) {
      case TabEnum.employees:
        return 'Employees';
      case TabEnum.rfidMachine:
        return 'RFID Machines';
      case TabEnum.rooms:
        return 'Rooms';
    }
  }

  IconData get icon {
    switch (this){

      case TabEnum.employees:
       return Icons.people_rounded;
      case TabEnum.rfidMachine:
        return Icons.microwave_rounded;
      case TabEnum.rooms:
        return Icons.location_city_rounded;
    }
  }
}