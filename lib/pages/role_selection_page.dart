import 'package:flutter/material.dart';
import '../models/user_role.dart';
import 'profile_setup_page.dart';

/// role_selection_page.dart
///
/// This page displays a list of user roles (defined in [UserRole]) that the user
/// can choose from during the onboarding or registration process.
///
/// Once a role is selected, the user is navigated to [ProfileSetupPage] to complete
/// their profile setup (name, DOB, etc.). The selected role is passed forward for saving.
///
/// Related files:
/// - user_role.dart
/// - profile_setup_page.dart


class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  final List<UserRole> _availableRoles = const [
    UserRole.guest,
    UserRole.member,
    UserRole.lead,
    UserRole.admin,
    UserRole.superadmin,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Role'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your role to continue',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This will determine your dashboard and available features',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _availableRoles.length,
                itemBuilder: (context, index) {
                  final role = _availableRoles[index];
                  return _buildRoleCard(context, role);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, UserRole role) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => _handleRoleSelection(context, role),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  role.icon,
                  size: 32,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  role.displayName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRoleSelection(BuildContext context, UserRole role) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileSetupPage(selectedRole: role),
      ),
    );
  }
}