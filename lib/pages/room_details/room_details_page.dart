import 'package:flutter/material.dart';

class RoomDetailsPage extends StatelessWidget {
  const RoomDetailsPage({super.key});

  static MaterialPageRoute<void> route({required int roomId}) => MaterialPageRoute(
    builder: (context) => const RoomDetailsPage(),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(),
    );
}
