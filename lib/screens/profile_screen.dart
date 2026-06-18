import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/database_helper.dart';
import 'welcome_screen.dart';
import 'add_menu_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Sruputer Setia';
  String _username = 'sruputer';
  String? _photoBase64; // ← TAMBAHAN
  bool _isLoading = true;
  List<Map<String, dynamic>> _orderHistory = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId != null) {
      final user = await DatabaseHelper.instance.getUser(userId);
      final orders =
          await DatabaseHelper.instance.getOrderHistory(userId: userId);

      if (user != null) {
        setState(() {
          _name = user['name'] ?? 'Sruputer Setia';
          _username = user['username'] ?? 'sruputer';
          _photoBase64 = user['photo']; // ← TAMBAHAN
          _orderHistory = orders;
        });
      }
    }
    setState(() => _isLoading = false);
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    await DatabaseHelper.instance.clearCart(userId: userId);
    await prefs.clear();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        (route) => false,
      );
    }
  }

  // ← TAMBAHAN: widget avatar yang cek foto atau fallback inisial
  Widget _buildAvatar() {
    final hasPhoto = _photoBase64 != null && _photoBase64!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.brown.shade300, width: 2),
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.brown.shade100,
        backgroundImage:
            hasPhoto ? MemoryImage(base64Decode(_photoBase64!)) : null,
        child: !hasPhoto
            ? Text(
                _name.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade800,
                ),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50.withOpacity(0.5),
      appBar: AppBar(
        title: const Text('Profil Sruputer'),
        backgroundColor: Colors.brown.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // User info header
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _buildAvatar(), // ← GANTI dari Container lama ke ini
                          const SizedBox(height: 16),
                          Text(
                            _name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown.shade900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '@$_username',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Menu Actions list
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ListTile(
                          leading: Icon(Icons.add_circle_outline,
                              color: Colors.amber.shade900),
                          title: const Text('Tambah Menu (Kustom)',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const AddMenuScreen()),
                            ).then((value) {
                              if (value == true) _loadProfileData();
                            });
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Icon(Icons.settings_outlined,
                              color: Colors.brown.shade800),
                          title: const Text('Setelan Akun',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SettingsScreen()),
                            ).then((value) =>
                                _loadProfileData()); // reload termasuk foto baru
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading:
                              const Icon(Icons.logout, color: Colors.redAccent),
                          title: const Text('Keluar dari Akun',
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold)),
                          onTap: _logout,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Order History Header
                  Row(
                    children: [
                      Icon(Icons.history, color: Colors.brown.shade900),
                      const SizedBox(width: 8),
                      Text(
                        'Riwayat Sruputan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Order history list
                  _orderHistory.isEmpty
                      ? Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: const Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Center(
                              child: Text(
                                'Belum ada riwayat transaksi.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _orderHistory.length,
                          itemBuilder: (context, index) {
                            final order = _orderHistory[index];
                            final double total =
                                (order['total_price'] as num).toDouble();
                            final time = order['order_time'] != null
                                ? DateTime.tryParse(order['order_time'])
                                    ?.toLocal()
                                : null;
                            final dateStr = time != null
                                ? '${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute.toString().padLeft(2, '0')}'
                                : order['order_time'] ?? '';

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.brown.shade50,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'Meja ${order['table_number']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.brown.shade800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          dateStr,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      order['items_summary'] ?? '',
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 13,
                                          height: 1.4),
                                    ),
                                    const Divider(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Bayar via: ${order['payment_method']}',
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          'Rp ${total.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            color: Colors.amber.shade900,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}
