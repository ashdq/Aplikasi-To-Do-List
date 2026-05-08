import 'package:flutter/material.dart';

import 'tugaspenting_page.dart';
import 'tugasbiasa_page.dart';
import 'daftartugas_page.dart';
import 'pengaturan_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.displayName, this.username});

  final String? displayName;
  final String? username;

  static const Color _primary = Color(0xFF4E9A91);
  static const Color _background = Color(0xFFF6F7FB);
  static const Color _textDark = Color(0xFF1E293B);
  static const Color _textMuted = Color(0xFF6B7280);
  static const Color _border = Color(0xFFE5E7EB);
  static const Color _green = Color(0xFF4CAF50);
  static const Color _red = Color(0xFFE24D3A);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayName = _weekdayName(now.weekday);
    final dateText = '${now.day} ${_monthName(now.month)} ${now.year}';

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        title: const Text('Beranda'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: _border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, ${displayName ?? username ?? 'User'}! 👋',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: _textDark,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$dayName, $dateText',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            title: 'TUGAS SELESAI',
                            value: '12',
                            valueColor: _green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            title: 'BELUM SELESAI',
                            value: '8',
                            valueColor: _red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: _border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TUGAS SELESAI / HARI [BONUS]',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: _textMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 110,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Expanded(child: _DayBar(label: 'Sen', value: 44)),
                          SizedBox(width: 8),
                          Expanded(child: _DayBar(label: 'Sel', value: 64)),
                          SizedBox(width: 8),
                          Expanded(child: _DayBar(label: 'Rab', value: 54)),
                          SizedBox(width: 8),
                          Expanded(child: _DayBar(label: 'Kam', value: 92)),
                          SizedBox(width: 8),
                          Expanded(child: _DayBar(label: 'Jum', value: 72)),
                          SizedBox(width: 8),
                          Expanded(child: _DayBar(label: 'Sab', value: 104)),
                          SizedBox(width: 8),
                          Expanded(child: _DayBar(label: 'Min', value: 58)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TugasPentingPage(),
                        ),
                      ),
                      child: _buildActionCard(
                        context,
                        icon: Icons.add,
                        iconColor: Colors.white,
                        iconBackground: const Color(0xFFD64034),
                        label: 'Tambah Tugas Penting',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TugasBiasaPage(),
                        ),
                      ),
                      child: _buildActionCard(
                        context,
                        icon: Icons.add,
                        iconColor: Colors.white,
                        iconBackground: const Color(0xFF49A24C),
                        label: 'Tambah Tugas Biasa',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DaftarTugasPage(),
                        ),
                      ),
                      child: _buildActionCard(
                        context,
                        icon: Icons.format_list_bulleted,
                        iconColor: Colors.white,
                        iconBackground: const Color(0xFF3F6DE0),
                        label: 'Daftar Tugas',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PengaturanPage(),
                        ),
                      ),
                      child: _buildActionCard(
                        context,
                        icon: Icons.settings,
                        iconColor: Colors.white,
                        iconBackground: const Color(0xFF77819A),
                        label: 'Pengaturan',
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

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: _textMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static String _weekdayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Senin';
      case DateTime.tuesday:
        return 'Selasa';
      case DateTime.wednesday:
        return 'Rabu';
      case DateTime.thursday:
        return 'Kamis';
      case DateTime.friday:
        return 'Jumat';
      case DateTime.saturday:
        return 'Sabtu';
      case DateTime.sunday:
        return 'Minggu';
      default:
        return '';
    }
  }

  static String _monthName(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }
}

class _DayBar extends StatelessWidget {
  const _DayBar({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: value.clamp(0, 90).toDouble(),
          decoration: BoxDecoration(
            color: HomePage._primary,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: HomePage._textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
