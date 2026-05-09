import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TugasException implements Exception {
  TugasException(this.message);

  final String message;

  @override
  String toString() => message;
}

class TugasItem {
  TugasItem({
    required this.id,
    required this.judul,
    required this.tanggal,
    required this.tipe,
    required this.status,
    this.deskripsi,
    this.completedAt,
  });

  final int id;
  final String judul;
  final DateTime tanggal;
  final String tipe; // penting | biasa
  String status; // belum selesai | selesai
  final String? deskripsi;
  final DateTime? completedAt;

  bool get isSelesai => status == 'selesai';
  set isSelesai(bool value) {
    status = value ? 'selesai' : 'belum selesai';
  }

  factory TugasItem.fromJson(Map<String, dynamic> json) {
    final rawDate = '${json['tenggat'] ?? ''}'.trim();
    final parsedDate = DateTime.tryParse(rawDate);

    return TugasItem(
      id: int.tryParse('${json['id']}') ?? 0,
      judul: '${json['judul_tugas'] ?? ''}',
      tanggal: parsedDate ?? DateTime.now(),
      tipe: '${json['jenis_tugas'] ?? 'biasa'}',
      status: '${json['status'] ?? 'belum selesai'}',
      completedAt: DateTime.tryParse('${json['completed_at'] ?? ''}'),
      deskripsi: json['deskripsi'] == null ? null : '${json['deskripsi']}',
    );
  }
}

class TugasService {
  TugasService({http.Client? client}) : _client = client ?? http.Client();

  static const String _androidBaseUrl = 'http://10.0.2.2/todolist_api';
  static const String _webFixedBaseUrl = 'http://localhost/todolist_api';

  final http.Client _client;
  String get baseUrl => kIsWeb ? _webFixedBaseUrl : _androidBaseUrl;

  Future<List<TugasItem>> fetchTugas() async {
    final uri = Uri.parse('$baseUrl/tugas.php');
    final response = await _client.get(uri);

    if (kDebugMode) {
      print('fetchTugas response status: ${response.statusCode}');
      print('fetchTugas response body: ${response.body}');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = null;
    }

    if (decoded is! Map<String, dynamic>) {
      throw TugasException('Format respons data tugas tidak valid.');
    }

    final success = decoded['success'] == true;
    final message = '${decoded['message'] ?? 'Gagal mengambil data tugas.'}';

    if (!success) {
      throw TugasException(message);
    }

    final rawList = decoded['data'];
    if (rawList is! List) {
      throw TugasException('Data tugas tidak ditemukan.');
    }

    return rawList
        .whereType<Map<String, dynamic>>()
        .map(TugasItem.fromJson)
        .toList();
  }

  Future<TugasItem> createTugas({
    required String jenisTugas,
    required DateTime tenggat,
    required String judulTugas,
    String? deskripsi,
  }) async {
    final uri = Uri.parse('$baseUrl/tugas.php');
    final response = await _client.post(
      uri,
      body: {
        'jenis_tugas': jenisTugas,
        'tenggat': tenggat.toIso8601String().split('T').first,
        'judul_tugas': judulTugas,
        'deskripsi': deskripsi ?? '',
      },
    );

    if (kDebugMode) {
      print('createTugas response status: ${response.statusCode}');
      print('createTugas response body: ${response.body}');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = null;
    }

    if (decoded is! Map<String, dynamic>) {
      throw TugasException('Format respons simpan tugas tidak valid.');
    }

    final success = decoded['success'] == true;
    final message = '${decoded['message'] ?? 'Gagal menyimpan tugas.'}';

    if (!success) {
      throw TugasException(message);
    }

    final rawData = decoded['data'];
    if (rawData is! Map<String, dynamic>) {
      throw TugasException('Data tugas baru tidak ditemukan.');
    }

    return TugasItem.fromJson(rawData);
  }

  Future<void> updateStatus({required int id, required bool isSelesai}) async {
    final uri = Uri.parse('$baseUrl/tugas.php');
    final response = await _client.post(
      uri,
      body: {
        'id': id.toString(),
        'status': isSelesai ? 'selesai' : 'belum selesai',
      },
    );

    if (kDebugMode) {
      print('updateStatus response status: ${response.statusCode}');
      print('updateStatus response body: ${response.body}');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = null;
    }

    if (decoded is! Map<String, dynamic>) {
      throw TugasException('Format respons update status tidak valid.');
    }

    final success = decoded['success'] == true;
    final message =
        '${decoded['message'] ?? 'Gagal memperbarui status tugas.'}';

    if (!success) {
      throw TugasException(message);
    }
  }

  void dispose() {
    _client.close();
  }
}
