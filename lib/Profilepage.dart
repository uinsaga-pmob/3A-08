import 'package:flutter/material.dart';
import 'bottom_nav.dart';
import 'settings.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EEDC),
      bottomNavigationBar: const BottomNav(current: 3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Text("Profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),

              const SizedBox(height: 10),

              // Profile Image
              const CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage("assets/cat.jpg"),
              ),

              const SizedBox(height: 12),
              const Text("jefrinichol", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 30),

              // Menu List
              buildMenu(context, Icons.settings, "Setting", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
              }),

              const SizedBox(height: 12),

              buildMenu(context, Icons.logout, "Logout", () {}),

              const SizedBox(height: 12),

              buildMenu(context, Icons.notifications_none, "Notification", () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenu(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFD9CFB6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 15),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            
          ],
        ),
      ),
    );
  }
}
