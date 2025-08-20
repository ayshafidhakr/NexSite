import 'package:flutter/material.dart';

class SmallBuilderDashboard extends StatelessWidget {
  const SmallBuilderDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Small builder dashboard")),
      body: const Center(
        child: Text("welcome, small builder"),
      ),
    );
  }
}
