import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../widgets/image_placeholder.dart';

class AddMenuScreen extends StatefulWidget {
  const AddMenuScreen({super.key});

  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _imagePathController = TextEditingController();

  String _selectedCategory = 'Coffee';
  bool _isLoading = false;
  String _imageSourceType = 'explorer'; // 'explorer' or 'url'

  // Preserved shortcut paths for URL selection
  final List<Map<String, String>> _urlShortcuts = [
    {'label': 'Mocacino Web URL', 'url': 'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=400&q=80'},
    {'label': 'Classic Coffee URL', 'url': 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400&q=80'},
    {'label': 'Matcha Sruput URL', 'url': 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=400&q=80'},
  ];

  @override
  void initState() {
    super.initState();
    // Default path from simulated explorer
    _imagePathController.text = '/storage/emulated/0/Download/good_day_mocacino.jpg';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _imagePathController.dispose();
    super.dispose();
  }

  // Browse file manager HP dialog
  void _openFileExplorerDialog() {
    showDialog(
      context: context,
      builder: (context) => _FileExplorerDialog(
        onFileSelected: (path) {
          setState(() {
            _imagePathController.text = path;
          });
        },
      ),
    );
  }

  void _saveMenu() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    final price = double.parse(_priceController.text.trim());
    final desc = _descController.text.trim();
    final imgPath = _imagePathController.text.trim();

    try {
      await DatabaseHelper.instance.insertMenuItem({
        'name': name,
        'category': _selectedCategory,
        'price': price,
        'description': desc,
        'image_path': imgPath.isEmpty ? 'good_day_mocacino' : imgPath,
        'is_favorite': 0,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Menu "$name" sukses disimpan ke SQLite!')),
              ],
            ),
            backgroundColor: const Color(0xFF5C3A21),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan menu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF2), // Warm Elegant Beige
      appBar: AppBar(
        title: const Text('TAMBAH MENU BARU'),
        backgroundColor: const Color(0xFF5C3A21), // Dark Espresso
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- FORM SPEC DOCUMENT HEADER (PDF STYLE) ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD2B48C), width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'KOPI SRUPUT APP SPECIFICATION v1.2',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'JetBrains Mono',
                            fontWeight: FontWeight.bold,
                            color: Colors.brown.shade800,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5C3A21),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'FORM-F02',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              // --- CAROUSEL PREVIEW BARU (REAL-TIME UPDATES) ---
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFD2B48C).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD2B48C).withOpacity(0.4)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.remove_red_eye_outlined, size: 16, color: Color(0xFF5C3A21)),
                        const SizedBox(width: 6),
                        Text(
                          'LIVE FORM PREVIEW',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown.shade900,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Simulated Mini Product Card
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4))
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: ImagePlaceholder(
                              imagePath: _imagePathController.text.trim(),
                              borderRadius: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5C3A21),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _selectedCategory.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _nameController.text.isEmpty ? 'Kopi Sruput Baru' : _nameController.text,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _descController.text.isEmpty ? 'Belum ada deskripsi...' : _descController.text,
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${_priceController.text.isEmpty ? '0' : double.tryParse(_priceController.text)?.toStringAsFixed(0) ?? _priceController.text}',
                                style: TextStyle(
                                  color: Colors.amber.shade900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),

              // --- NAMA MENU ---
              TextFormField(
                controller: _nameController,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Nama Menu',
                  labelStyle: const TextStyle(color: Colors.brown, fontSize: 13),
                  prefixIcon: const Icon(Icons.coffee, color: Color(0xFF5C3A21)),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFD2B48C), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF5C3A21), width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama menu wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- KATEGORI (RADIO SELECTION) ---
              const Text(
                'Kategori Menu',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCategory = 'Coffee';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedCategory == 'Coffee' ? const Color(0xFF5C3A21) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _selectedCategory == 'Coffee' ? const Color(0xFF5C3A21) : const Color(0xFFD2B48C),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Coffee',
                            style: TextStyle(
                              color: _selectedCategory == 'Coffee' ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCategory = 'Non Coffee';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedCategory == 'Non Coffee' ? const Color(0xFF5C3A21) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _selectedCategory == 'Non Coffee' ? const Color(0xFF5C3A21) : const Color(0xFFD2B48C),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Non Coffee',
                            style: TextStyle(
                              color: _selectedCategory == 'Non Coffee' ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- HARGA ---
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Harga Menu (Rupiah)',
                  labelStyle: const TextStyle(color: Colors.brown, fontSize: 13),
                  prefixIcon: const Icon(Icons.payments_outlined, color: Color(0xFF5C3A21)),
                  suffixText: 'Rupiah',
                  suffixStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFD2B48C), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF5C3A21), width: 2),
                  ),
                ),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Harga wajib diisi';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Harga harus berupa angka valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- DESKRIPSI ---
              TextFormField(
                controller: _descController,
                maxLines: 3,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Deskripsi Kopi / Sruputan',
                  labelStyle: const TextStyle(color: Colors.brown, fontSize: 13),
                  prefixIcon: const Icon(Icons.description_outlined, color: Color(0xFF5C3A21)),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFD2B48C), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF5C3A21), width: 2),
                  ),
                ),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- SOURCE SELECTION & PATH INPUT FIELD ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD2B48C), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.camera_alt_outlined, color: Color(0xFF5C3A21), size: 18),
                        const SizedBox(width: 8),
                        const Text(
                          'Sumber Foto Menu',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Custom toggle buttons for picker source
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _imageSourceType = 'explorer';
                                _imagePathController.text = '/storage/emulated/0/Download/good_day_mocacino.jpg';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _imageSourceType == 'explorer' ? const Color(0xFFD2B48C).withOpacity(0.3) : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _imageSourceType == 'explorer' ? const Color(0xFF5C3A21) : Colors.grey.shade300,
                                  width: _imageSourceType == 'explorer' ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.folder_open_outlined, size: 16, color: _imageSourceType == 'explorer' ? const Color(0xFF5C3A21) : Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Explorer HP',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _imageSourceType == 'explorer' ? const Color(0xFF5C3A21) : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _imageSourceType = 'url';
                                _imagePathController.text = 'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=400&q=80';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _imageSourceType == 'url' ? const Color(0xFFD2B48C).withOpacity(0.3) : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _imageSourceType == 'url' ? const Color(0xFF5C3A21) : Colors.grey.shade300,
                                  width: _imageSourceType == 'url' ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.link, size: 16, color: _imageSourceType == 'url' ? const Color(0xFF5C3A21) : Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Web URL / Aset',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _imageSourceType == 'url' ? const Color(0xFF5C3A21) : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Title instruction based on selection
                    Text(
                      _imageSourceType == 'explorer' 
                        ? 'Direktori File Explorer HP :'
                        : 'Web Image URL / Key Preset :',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),

                    // Input Field
                    TextFormField(
                      controller: _imagePathController,
                      style: const TextStyle(fontSize: 12, fontFamily: 'JetBrains Mono', color: Colors.black),
                      decoration: InputDecoration(
                        hintText: _imageSourceType == 'explorer' 
                          ? 'Mulai dengan /storage/emulated/...' 
                          : 'Masukan URL https://...',
                        prefixIcon: Icon(
                          _imageSourceType == 'explorer' ? Icons.sd_card_outlined : Icons.insert_link,
                          size: 18,
                        ),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),

                    // Conditionally show buttons
                    if (_imageSourceType == 'explorer') ...[
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _openFileExplorerDialog,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF5C3A21), width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.file_open_outlined, color: Color(0xFF5C3A21), size: 18),
                          label: const Text(
                            'Buka File Explorer HP',
                            style: TextStyle(color: Color(0xFF5C3A21), fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                    ] else ...[
                      // Quick preset buttons for URL choice
                      const Text(
                        'Pilihan URL Cepat:',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: _urlShortcuts.map((shortcut) {
                          return ActionChip(
                            label: Text(
                              shortcut['label']!,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: const Color(0xFFD2B48C).withOpacity(0.2),
                            onPressed: () {
                              setState(() {
                                _imagePathController.text = shortcut['url']!;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- SUBMIT BUTTONS ---
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        'BATAL',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveMenu,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C3A21),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              'SIMPAN KE SQLITE',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dialog widget that simulates browsing an Android device storage / file explorer structure
class _FileExplorerDialog extends StatefulWidget {
  final Function(String) onFileSelected;

  const _FileExplorerDialog({required this.onFileSelected});

  @override
  State<_FileExplorerDialog> createState() => _FileExplorerDialogState();
}

class _FileExplorerDialogState extends State<_FileExplorerDialog> {
  String _currentFolder = '/Internal Storage';
  
  // Folders map to simulate tree
  final Map<String, List<Map<String, dynamic>>> _fileSystem = {
    '/Internal Storage': [
      {'name': 'Download', 'is_folder': true, 'path': '/Internal Storage/Download'},
      {'name': 'DCIM', 'is_folder': true, 'path': '/Internal Storage/DCIM'},
      {'name': 'Pictures', 'is_folder': true, 'path': '/Internal Storage/Pictures'},
      {'name': 'Documents', 'is_folder': true, 'path': '/Internal Storage/Documents'},
    ],
    '/Internal Storage/Download': [
      {'name': 'good_day_moccacino.jpg', 'is_folder': false, 'path': '/storage/emulated/0/Download/good_day_mocacino.jpg', 'size': '1.2 MB', 'emoji': '🧋'},
      {'name': 'nescafe_classic.jpg', 'is_folder': false, 'path': '/storage/emulated/0/Download/nescafe_classic.jpg', 'size': '840 KB', 'emoji': '☕'},
      {'name': 'abc_kopi_susu.jpg', 'is_folder': false, 'path': '/storage/emulated/0/Download/abc_kopi_susu.jpg', 'size': '1.5 MB', 'emoji': '🥛'},
    ],
    '/Internal Storage/DCIM': [
      {'name': 'Camera', 'is_folder': true, 'path': '/Internal Storage/DCIM/Camera'},
    ],
    '/Internal Storage/DCIM/Camera': [
      {'name': 'photo_2026_sruput.jpg', 'is_folder': false, 'path': '/storage/emulated/0/DCIM/Camera/photo_2026_sruput.jpg', 'size': '2.1 MB', 'emoji': '📸'},
    ],
    '/Internal Storage/Pictures': [
      {'name': 'chocolatos_matcha.png', 'is_folder': false, 'path': '/storage/emulated/0/Pictures/chocolatos_matcha.png', 'size': '520 KB', 'emoji': '🍵'},
      {'name': 'chocolatos_choco.png', 'is_folder': false, 'path': '/storage/emulated/0/Pictures/chocolatos_choco.png', 'size': '610 KB', 'emoji': '🍫'},
      {'name': 'drink_beng_beng.png', 'is_folder': false, 'path': '/storage/emulated/0/Pictures/drink_beng_beng.png', 'size': '490 KB', 'emoji': '🥤'},
    ],
    '/Internal Storage/Documents': [
      {'name': 'coffee_recipe.pdf', 'is_folder': false, 'path': '/storage/emulated/0/Documents/coffee_recipe.pdf', 'size': '3.2 MB', 'emoji': '📄', 'disabled': true},
      {'name': 'financial_report.xlsx', 'is_folder': false, 'path': '/storage/emulated/0/Documents/financial_report.xlsx', 'size': '1.1 MB', 'emoji': '📊', 'disabled': true},
    ]
  };

  @override
  Widget build(BuildContext context) {
    final contents = _fileSystem[_currentFolder] ?? [];

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: Color(0xFF5C3A21),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Row(
          children: [
            const Icon(Icons.phone_android_outlined, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'File Manager HP',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white70, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: double.maxFinite,
        height: 380,
        child: Column(
          children: [
            // Current path breadcrumb line
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  const Icon(Icons.folder, size: 14, color: Colors.amber),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _currentFolder,
                      style: const TextStyle(fontSize: 11, fontFamily: 'JetBrains Mono', color: Colors.grey, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_currentFolder != '/Internal Storage')
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          // Simple parent directory calculation
                          final parts = _currentFolder.split('/');
                          parts.removeLast();
                          _currentFolder = parts.join('/');
                          if (_currentFolder.isEmpty) {
                            _currentFolder = '/Internal Storage';
                          }
                        });
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_upward, size: 12, color: Color(0xFF5C3A21)),
                          SizedBox(width: 2),
                          Text('UP', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF5C3A21))),
                        ],
                      ),
                    )
                ],
              ),
            ),

            // File items
            Expanded(
              child: contents.isEmpty
                  ? const Center(
                      child: Text('Folder Kosong', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: contents.length,
                      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF2F0E4)),
                      itemBuilder: (context, index) {
                        final item = contents[index];
                        final isFolder = item['is_folder'] == true;
                        final isDisabled = item['disabled'] == true;

                        return ListTile(
                          onTap: isDisabled
                              ? () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('File format ini tidak didukung sebagai Menu Image!'),
                                      duration: Duration(milliseconds: 1000),
                                    ),
                                  );
                                }
                              : () {
                                  if (isFolder) {
                                    setState(() {
                                      _currentFolder = item['path'];
                                    });
                                  } else {
                                    // File selected!
                                    widget.onFileSelected(item['path']);
                                    Navigator.of(context).pop();
                                  }
                                },
                          leading: isFolder
                              ? const Icon(Icons.folder_open, color: Colors.amber, size: 36)
                              : Container(
                                  width: 36,
                                  height: 36,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.brown.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item['emoji'] ?? '🖼️',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                          title: Text(
                            item['name'],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isFolder ? FontWeight.bold : FontWeight.w500,
                              color: isDisabled ? Colors.grey : Colors.black87,
                              decoration: isDisabled ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          subtitle: isFolder
                              ? const Text('Folder', style: TextStyle(fontSize: 11, color: Colors.grey))
                              : Text(item['size'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          trailing: isFolder
                              ? const Icon(Icons.chevron_right, size: 16)
                              : const Icon(Icons.check_circle_outline, size: 16, color: Colors.grey),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
