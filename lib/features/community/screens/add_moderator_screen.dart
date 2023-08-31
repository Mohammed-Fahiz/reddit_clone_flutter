import 'package:flutter/material.dart';

class AddModeratorScreen extends StatelessWidget {
  final String name;
  const AddModeratorScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add moderators"),
      ),
    );
  }
}
