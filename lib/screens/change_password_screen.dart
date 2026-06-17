import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/database_helper.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  void _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('user_id');
  }

  void _changePassword() async {
    if (!_formKey.currentState!.validate() || _userId == null) return;
    setState(() => _isLoading = true);

    try {
      // Ambil data user dari DB
      final user = await DatabaseHelper.instance.getUser(_userId!);
      if (user == null) throw Exception('User tidak ditemukan');

      // Cek password lama
      final oldPassword = _oldPasswordController.text.trim();
      if (user['password'] != oldPassword) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password lama tidak sesuai'),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      // Update password baru
      await DatabaseHelper.instance.updateUserProfile(_userId!, {
        'password': _newPasswordController.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password berhasil diubah!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengubah password: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Ubah Password'),
        backgroundColor: Colors.brown.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Info box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.brown.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.brown.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.brown.shade700, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Password baru minimal 6 karakter dan tidak boleh sama dengan password lama.',
                              style: TextStyle(fontSize: 12, color: Colors.brown.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Password Lama
                    TextFormField(
                      controller: _oldPasswordController,
                      obscureText: _obscureOld,
                      decoration: InputDecoration(
                        labelText: 'Password Lama',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureOld ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () => setState(() => _obscureOld = !_obscureOld),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password lama wajib diisi';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Baru
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: _obscureNew,
                      decoration: InputDecoration(
                        labelText: 'Password Baru',
                        prefixIcon: const Icon(Icons.lock_reset_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () => setState(() => _obscureNew = !_obscureNew),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password baru wajib diisi';
                        if (v.length < 6) return 'Password minimal 6 karakter';
                        if (v == _oldPasswordController.text.trim()) {
                          return 'Password baru tidak boleh sama dengan password lama';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Konfirmasi Password Baru
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        labelText: 'Konfirmasi Password Baru',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Konfirmasi password wajib diisi';
                        if (v != _newPasswordController.text.trim()) {
                          return 'Password tidak cocok';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown.shade800,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Simpan Password Baru',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}