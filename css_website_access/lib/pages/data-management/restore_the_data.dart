import 'dart:convert';
import 'package:http/http.dart' as http;

class BackupModel {
  final int id;
  final String backupFileName;
  final String backupDate;

  BackupModel({
    required this.id,
    required this.backupFileName,
    required this.backupDate,
  });

  factory BackupModel.fromJson(Map<String, dynamic> json) {
    return BackupModel(
      id: int.parse(json['id']),
      backupFileName: json['backup_file_name'],
      backupDate: json['backup_date'],
    );
  }
}

Future<List<BackupModel>> fetchBackups() async {
  final response = await http.get(Uri.parse(
      "http://192.168.1.104/database/backup-restore/fetch_backups.php"));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => BackupModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load backups');
  }
}
