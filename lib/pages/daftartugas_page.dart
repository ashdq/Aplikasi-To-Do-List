import 'package:flutter/material.dart';

class DaftarTugasPage extends StatefulWidget {
  const DaftarTugasPage({super.key});

  @override
  State<DaftarTugasPage> createState() => _DaftarTugasPageState();
}

class _TugasItem {
  final String judul;
  final DateTime tanggal;
  final String tipe; // 'penting' atau 'biasa'
  bool isSelesai;

  _TugasItem({
    required this.judul,
    required this.tanggal,
    required this.tipe,
    this.isSelesai = false,
  });
}

class _DaftarTugasPageState extends State<DaftarTugasPage> {
  static const Color _primary = Color(0xFF4E9A91);
  static const Color _background = Color(0xFFF6F7FB);
  static const Color _textDark = Color(0xFF1E293B);
  static const Color _textMuted = Color(0xFF6B7280);
  static const Color _border = Color(0xFFE5E7EB);
  static const Color _colorPenting = Color(0xFFD64034);
  static const Color _colorBiasa = Color(0xFF49A24C);

  late List<_TugasItem> tugas;

  @override
  void initState() {
    super.initState();
    tugas = [
      _TugasItem(
        judul: 'Submit laporan akhir',
        tanggal: DateTime(2026, 5, 5),
        tipe: 'penting',
      ),
      _TugasItem(
        judul: 'Beli buah di pasar',
        tanggal: DateTime(2026, 5, 4),
        tipe: 'biasa',
        isSelesai: true,
      ),
      _TugasItem(
        judul: 'Meeting tim Sprint',
        tanggal: DateTime(2026, 5, 6),
        tipe: 'penting',
      ),
      _TugasItem(
        judul: 'Olahraga sore',
        tanggal: DateTime(2026, 5, 5),
        tipe: 'biasa',
      ),
      _TugasItem(
        judul: 'Revisi proposal',
        tanggal: DateTime(2026, 5, 7),
        tipe: 'penting',
      ),
      _TugasItem(
        judul: 'Telepon orang tua',
        tanggal: DateTime(2026, 5, 3),
        tipe: 'biasa',
        isSelesai: true,
      ),
    ];
  }

  String _formatDate(DateTime date) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
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
          'Daftar Tugas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: tugas.length,
          itemBuilder: (context, index) {
            final item = tugas[index];
            final isPenting = item.tipe == 'penting';
            final flagColor = isPenting ? _colorPenting : _colorBiasa;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: Checkbox(
                          value: item.isSelesai,
                          onChanged: (value) {
                            setState(() {
                              item.isSelesai = value ?? false;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: WidgetStateBorderSide.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return const BorderSide(color: _colorBiasa);
                            }
                            return const BorderSide(color: _border);
                          }),
                          fillColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return _colorBiasa;
                            }
                            return Colors.white;
                          }),
                          checkColor: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.judul,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: item.isSelesai
                                        ? _textMuted
                                        : _textDark,
                                    fontWeight: FontWeight.w600,
                                    decoration: item.isSelesai
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  _formatDate(item.tanggal),
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: _textMuted,
                                        fontSize: 11,
                                      ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '· ${isPenting ? 'Penting' : 'Biasa'}',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: _textMuted,
                                        fontSize: 11,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: flagColor,
                          shape: BoxShape.circle,
                        ),
                        child: CustomPaint(painter: _FlagPainter(flagColor)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FlagPainter extends CustomPainter {
  final Color color;

  _FlagPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw triangle (flag)
    final path = Path();
    path.moveTo(size.width / 2, size.height / 4);
    path.lineTo(size.width / 4, size.height / 2);
    path.lineTo(size.width * 0.75, size.height / 2);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_FlagPainter oldDelegate) => false;
}
