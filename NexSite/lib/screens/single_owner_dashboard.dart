import 'package:flutter/material.dart';

class SingleOwnerDashboard extends StatelessWidget {
  const SingleOwnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("single owner dashboard")),
      body: const Center(
        child: Text("welcome, single owner"),
      ),
    );
  }
}
