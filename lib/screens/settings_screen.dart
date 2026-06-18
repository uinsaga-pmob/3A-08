import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/database_helper.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();

  int? _userId;
  bool _isLoading = true;
  String? _photoBase64; // Foto yang tersimpan di DB (base64)
  File? _newPhotoFile; // Foto baru yang dipilih user (belum disimpan)

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getInt('user_id');

    if (uid != null) {
      _userId = uid;
      final user = await DatabaseHelper.instance.getUser(uid);
      if (user != null) {
        setState(() {
          _nameController.text = user['name'] ?? '';
          _usernameController.text = user['username'] ?? '';
          _photoBase64 = user['photo']; // ambil base64 dari DB
        });
      }
    }
    setState(() => _isLoading = false);
  }

  // ── Pilih foto dari galeri atau kamera ──────────────────────────────────
  void _pickPhoto() async {
    final picker = ImagePicker();

    // Tanya user: galeri atau kamera
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Pilih Sumber Foto',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.brown.shade900),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.brown.shade50,
                child: Icon(Icons.photo_library_outlined,
                    color: Colors.brown.shade700),
              ),
              title: const Text('Galeri'),
              subtitle: const Text('Pilih dari galeri foto'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.brown.shade50,
                child: Icon(Icons.camera_alt_outlined,
                    color: Colors.brown.shade700),
              ),
              title: const Text('Kamera'),
              subtitle: const Text('Ambil foto baru'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picked = await picker.pickImage(
      source: source,
      imageQuality: 70, // kompres agar base64 tidak terlalu besar
      maxWidth: 512,
      maxHeight: 512,
    );

    if (picked != null) {
      setState(() => _newPhotoFile = File(picked.path));
    }
  }

  // ── Hapus foto profil ───────────────────────────────────────────────────
  void _removePhoto() {
    setState(() {
      _newPhotoFile = null;
      _photoBase64 = null;
    });
  }

  // ── Simpan profil ───────────────────────────────────────────────────────
  void _updateProfile() async {
    if (!_formKey.currentState!.validate() || _userId == null) return;
    setState(() => _isLoading = true);

    try {
      // Konversi foto baru ke base64 jika ada
      String? photoBase64ToSave = _photoBase64;
      if (_newPhotoFile != null) {
        final bytes = await _newPhotoFile!.readAsBytes();
        photoBase64ToSave = base64Encode(bytes);
      }

      await DatabaseHelper.instance.updateUserProfile(_userId!, {
        'name': _nameController.text.trim(),
        'username': _usernameController.text.trim(),
        'photo': photoBase64ToSave, // null = hapus foto
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _nameController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Profil berhasil diperbarui!'),
              backgroundColor: Colors.green),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Gagal memperbarui profil: $e'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _changePassword() {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => const ChangePasswordScreen()));
  }

  // ── Widget foto profil ──────────────────────────────────────────────────
  Widget _buildPhotoAvatar() {
    ImageProvider? imageProvider;

    if (_newPhotoFile != null) {
      // Foto baru yang baru dipilih (dari File)
      imageProvider = FileImage(_newPhotoFile!);
    } else if (_photoBase64 != null && _photoBase64!.isNotEmpty) {
      // Foto lama dari DB (base64)
      imageProvider = MemoryImage(base64Decode(_photoBase64!));
    }

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 52,
            backgroundColor: Colors.brown.shade100,
            backgroundImage: imageProvider,
            child: imageProvider == null
                ? Icon(Icons.person, size: 52, color: Colors.brown.shade400)
                : null,
          ),
          // Tombol kamera
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickPhoto,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.brown.shade800,
                child:
                    const Icon(Icons.camera_alt, size: 16, color: Colors.white),
              ),
            ),
          ),
          // Tombol hapus foto (muncul hanya jika ada foto)
          if (imageProvider != null)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: _removePhoto,
                child: CircleAvatar(
                  radius: 13,
                  backgroundColor: const Color.fromARGB(255, 177, 4, 1),
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Setelan Akun'),
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
                    // ── Foto Profil ──────────────────────────────
                    _buildPhotoAvatar(),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: _pickPhoto,
                        child: Text('Ubah Foto Profil',
                            style: TextStyle(color: Colors.brown.shade700)),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Informasi Akun ───────────────────────────
                    _sectionLabel('Informasi Akun'),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Lengkap',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: const Icon(Icons.alternate_email),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        helperText:
                            'Gunakan huruf kecil, angka, atau underscore',
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Username wajib diisi';
                        if (v.contains(' '))
                          return 'Username tidak boleh mengandung spasi';
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown.shade800,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Simpan Perubahan',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 32),

                    // ── Keamanan ──────────────────────────────────
                    _sectionLabel('Keamanan'),
                    const SizedBox(height: 12),

                    _securityTile(
                      icon: Icons.lock_outline,
                      title: 'Ubah Password',
                      subtitle: 'Ganti kata sandi akun Anda',
                      onTap: _changePassword,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.brown.shade700,
          letterSpacing: 0.8),
    );
  }

  Widget _securityTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? Colors.brown.shade700, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(subtitle,
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
