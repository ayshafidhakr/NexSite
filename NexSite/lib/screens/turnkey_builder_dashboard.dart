import 'package:flutter/material.dart';

class TurnkeyBuilderDashboard extends StatelessWidget {
  const TurnkeyBuilderDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Turnkey builder dashboard")),
      body: const Center(
        child: Text("welcome, turn-key builder"),
      ),
    );
  }
}
