import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/session.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  static const Color _primary = Color(0xFF4E9A91);
  static const Color _background = Color(0xFFF6F7FB);
  static const Color _textDark = Color(0xFF1E293B);
  static const Color _textMuted = Color(0xFF6B7280);
  static const Color _border = Color(0xFFE5E7EB);

  late TextEditingController _passwordLamaController;
  late TextEditingController _passwordBaruController;
  final AuthService _authService = AuthService();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _passwordLamaController = TextEditingController();
    _passwordBaruController = TextEditingController();
    // Refresh UI after first frame to ensure Session.currentUser is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Force rebuild when page is shown (ensure Session is visible)
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _passwordLamaController.dispose();
    _passwordBaruController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GANTI PASSWORD SECTION
              Text(
                'GANTI PASSWORD',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: _textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PASSWORD SAAT INI',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: _textMuted,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordLamaController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '••••',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: _border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: _border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: _primary),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'PASSWORD BARU',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: _textMuted,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordBaruController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: _border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: _border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: _primary),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _isSaving
                            ? null
                            : () async {
                                final current = Session.currentUser;
                                if (current == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('User belum login.'),
                                    ),
                                  );
                                  return;
                                }

                                final oldPass = _passwordLamaController.text;
                                final newPass = _passwordBaruController.text;
                                if (oldPass.isEmpty || newPass.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Semua field wajib diisi.'),
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  _isSaving = true;
                                });

                                try {
                                  await _authService.changePassword(
                                    username: current.username,
                                    oldPassword: oldPass,
                                    newPassword: newPass,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Password berhasil diubah.',
                                      ),
                                    ),
                                  );
                                  _passwordLamaController.clear();
                                  _passwordBaruController.clear();
                                } on AuthException catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.message)),
                                  );
                                } catch (_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Gagal menghubungi server.',
                                      ),
                                    ),
                                  );
                                } finally {
                                  setState(() {
                                    _isSaving = false;
                                  });
                                }
                              },
                        child: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'SIMPAN PASSWORD',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // DEVELOPER SECTION
              Text(
                'DEVELOPER',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: _textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B95A6),
                        shape: BoxShape.circle,
                        border: Border.all(color: _border, width: 2),
                      ),
                      child: ClipOval(
                        child: Image.asset('pic/ye.jpg', fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Session.currentUser?.nama ?? '[Nama Mahasiswa]',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: _textDark,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'NIM: ${Session.currentUser?.nim ?? '[xxxxxxxxxx]'}',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: _textMuted, fontSize: 12),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'DEVELOPER APLIKASI',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: _primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
