import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'dart:math';
import '../models/user_role.dart';
import 'package:multi_role_flutter_auth/services/supabase_services.dart';
import 'package:multi_role_flutter_auth/dashboard/dashboard_router.dart';

class ProfileSetupPage extends StatefulWidget {
  final UserRole selectedRole;

  const ProfileSetupPage({super.key, required this.selectedRole});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = SupabaseService.getCurrentUser();
    if (user?.email != null) {
      _emailController.text = user!.email!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRoleInfo(),
                    const SizedBox(height: 24),
                    _buildNameField(),
                    const SizedBox(height: 16),
                    _buildEmailField(),
                    const SizedBox(height: 32),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildRoleInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(widget.selectedRole.icon, color: Colors.blue, size: 24),
          const SizedBox(width: 12),
          Text(
            'Selected Role: ${widget.selectedRole.displayName}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Full Name *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your full name';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      enabled: false,
      decoration: const InputDecoration(
        labelText: 'Email (auto-filled)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
        filled: true,
        fillColor: Color(0xFFEEEEEE),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value)) {
            return 'Please enter a valid email address';
          }
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _submitProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Complete Setup',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = SupabaseService.getCurrentUser();
    if (user == null) {
      _showErrorDialog('Please sign in to continue');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Step 1: Insert user profile WITHOUT the custom ID
      final insertResult = await SupabaseService.client
          .from('user_profiles')
          .insert({
            'user_id': user.id,
            'email': user.email,
            'name': _nameController.text.trim(),
            'role': widget.selectedRole.name,
          })
          .select()
          .maybeSingle();

      if (insertResult == null) {
        _showErrorDialog('Failed to create user profile.');
        return;
      }

      // Step 2: Generate the next available custom ID
      bool idAssigned = false;
      int retryCount = 0;
      const maxRetries = 5;

      while (!idAssigned && retryCount < maxRetries) {
        final customUserId = await generateUniqueUserId();

        try {
          final updateResult = await SupabaseService.client
              .from('user_profiles')
              .update({'custom_user_id': customUserId})
              .eq('user_id', user.id)
              .select()
              .maybeSingle();

          if (updateResult != null &&
              updateResult['custom_user_id'] == customUserId) {
            idAssigned = true;
          } else {
            retryCount++;
            await Future.delayed(const Duration(milliseconds: 150));
          }
        } catch (e) {
          // Check if it's a duplicate key error
          if (e.toString().contains('duplicate key value')) {
            retryCount++;
            await Future.delayed(const Duration(milliseconds: 150));
          } else {
            rethrow; // some other unknown error
          }
        }
      }

      if (!idAssigned) {
        _showErrorDialog(
          'Failed to assign a unique user ID after several attempts.',
        );
        return;
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardRouter(role: widget.selectedRole),
          ),
        );
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<String> generateUniqueUserId() async {
    final prefix = widget.selectedRole.prefix;
    final random = Random();

    for (int i = 0; i < 10; i++) {
      final number = random.nextInt(10000); // 0 to 9999
      final candidateId = '$prefix${number.toString().padLeft(4, '0')}';

      final existing = await SupabaseService.client
          .from('user_profiles')
          .select('custom_user_id')
          .eq('custom_user_id', candidateId)
          .maybeSingle();

      if (existing == null) {
        return candidateId; // Unique!
      }
    }

    throw Exception('Failed to generate unique user ID after 10 attempts');
  }
}
