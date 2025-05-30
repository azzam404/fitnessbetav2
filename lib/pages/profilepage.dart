import 'package:fitnessbetav2/pages/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart'; // make sure this path matches your project

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = authService.value.currentUser;

    String username = user?.displayName ?? 'No Username';
    String email = user?.email ?? 'No Email';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white24,
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                username,
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                email,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),
            _buildShadowButton('Update Username', onPressed: () => _updateUsername(context)),
            const SizedBox(height: 15),
            _buildShadowButton('Change Password', onPressed: () => _changePassword(context)),
            const SizedBox(height: 15),
            _buildShadowButton('Delete My Account', onPressed: () => _deleteAccount(context)),
            const SizedBox(height: 15),
            _buildShadowButton(
              'Logout',
              color: Colors.redAccent,
              textColor: Colors.white,
              onPressed: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShadowButton(
      String text, {
        required VoidCallback onPressed,
        Color color = const Color.fromRGBO(19, 137, 175, 1.0),
        Color textColor = Colors.black,
      }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(text),
      ),
    );
  }

  Future<void> _updateUsername(BuildContext context) async {
    TextEditingController usernameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Update Username'),
        content: TextField(
          controller: usernameController,
          decoration: const InputDecoration(labelText: 'New Username'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                await authService.value.updateUsername(username: usernameController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Username updated!')));
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    TextEditingController currentPassController = TextEditingController();
    TextEditingController newPassController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPassController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                String email = authService.value.currentUser!.email!;
                await authService.value.resetPasswordFromCurrentPassword(
                  email: email,
                  currentPassword: currentPassController.text,
                  newPassword: newPassController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed!')));
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    TextEditingController passController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account'),
        content: TextField(
          controller: passController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              try {
                String email = authService.value.currentUser!.email!;
                await authService.value.deleteAccount(
                  email: email,
                  password: passController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account deleted')));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await authService.value.signOut();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out')));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
