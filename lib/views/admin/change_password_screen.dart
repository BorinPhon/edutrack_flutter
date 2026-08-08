import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {

  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hideOldPassword = true;
  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<AuthProvider>();

    final success = await provider.changePassword(
      oldPassword: _oldPasswordController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Password changed successfully."),
        ),
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            provider.errorMessage ??
                "Unable to change password.",
          ),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              //-----------------------------------
              // OLD PASSWORD
              //-----------------------------------

              TextFormField(
                controller: _oldPasswordController,
                obscureText: _hideOldPassword,

                decoration: InputDecoration(
                  labelText: "Old Password",

                  prefixIcon: const Icon(Icons.lock),

                  suffixIcon: IconButton(
                    icon: Icon(
                      _hideOldPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _hideOldPassword =
                        !_hideOldPassword;
                      });
                    },
                  ),
                ),

                validator: (value) {

                  if (value == null || value.isEmpty) {
                    return "Old password is required.";
                  }

                  return null;

                },
              ),

              const SizedBox(height: 20),

              //-----------------------------------
              // NEW PASSWORD
              //-----------------------------------

              TextFormField(
                controller: _newPasswordController,
                obscureText: _hideNewPassword,

                decoration: InputDecoration(
                  labelText: "New Password",

                  prefixIcon: const Icon(Icons.lock_outline),

                  suffixIcon: IconButton(
                    icon: Icon(
                      _hideNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _hideNewPassword =
                        !_hideNewPassword;
                      });
                    },
                  ),
                ),

                validator: (value) {

                  if (value == null || value.isEmpty) {
                    return "New password is required.";
                  }

                  if (value.length < 6) {
                    return "Password must be at least 6 characters.";
                  }

                  return null;

                },
              ),

              const SizedBox(height: 20),

              //-----------------------------------
              // CONFIRM PASSWORD
              //-----------------------------------

              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _hideConfirmPassword,

                decoration: InputDecoration(
                  labelText: "Confirm Password",

                  prefixIcon: const Icon(Icons.lock_reset),

                  suffixIcon: IconButton(
                    icon: Icon(
                      _hideConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _hideConfirmPassword =
                        !_hideConfirmPassword;
                      });
                    },
                  ),
                ),

                validator: (value) {

                  if (value == null || value.isEmpty) {
                    return "Confirm password is required.";
                  }

                  if (value !=
                      _newPasswordController.text) {

                    return "Passwords do not match.";

                  }

                  return null;

                },
              ),

              const SizedBox(height: 40),

              //-----------------------------------
              // BUTTON
              //-----------------------------------

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(

                  onPressed: authProvider.isLoading
                      ? null
                      : _changePassword,

                  child: authProvider.isLoading
                      ? const SizedBox(
                    width: 25,
                    height: 25,
                    child:
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}