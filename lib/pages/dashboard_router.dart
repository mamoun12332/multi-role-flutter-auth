import 'package:flutter/material.dart';
import '../models/user_role.dart';

//Dashboard imports


class DashboardRouter extends StatelessWidget {
  final UserRole role;

  const DashboardRouter({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case UserRole.guest:
        return const BlankPage();
      case UserRole.member:
        return const BlankPage();
      case UserRole.lead:
        return const BlankPage();
      case UserRole.admin:
        return const BlankPage();
      case UserRole.superadmin:
        return const BlankPage();
    }
  }
}

class BlankPage extends StatelessWidget {
  final String title;
  const BlankPage({super.key, this.title = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title.isEmpty ? 'Dashboard' : title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Welcome to your dashboard!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class SimpleFleetManagerDashboard extends StatelessWidget {
  const SimpleFleetManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const BlankPage(title: 'Fleet Manager Dashboard');
  }
}
