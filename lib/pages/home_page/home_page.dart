import 'package:fe_cnpmn/enums/tab_enum.dart';
import 'package:fe_cnpmn/pages/employees_page/employees_page.dart';
import 'package:fe_cnpmn/pages/rfid_machines_page/rfid_machines_page.dart';
import 'package:fe_cnpmn/pages/rooms_page/rooms_pages.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabEnum _currentTab = TabEnum.employees;

  void setTab(TabEnum newTab) {
    setState(() {
      _currentTab = newTab;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: IndexedStack(
        index: _currentTab.index,
        children: [
          EmployeesPage(),
          RfidMachinePage(),
          RoomPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab.index,
        onTap: (index) => setTab(TabEnum.values[index]),
        items: TabEnum.values
            .map(
              (tab) => BottomNavigationBarItem(
                icon: Icon(tab.icon),
                label: tab.translationName,
              ),
            )
            .toList(),
      ),
    );
}
