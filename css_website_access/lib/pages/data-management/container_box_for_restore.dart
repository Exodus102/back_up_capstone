import 'package:css_website_access/pages/data-management/no_bg_no_icon.dart';
import 'package:css_website_access/pages/data-management/restore_the_data.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ContainerBoxForRestore extends StatefulWidget {
  final double width;
  const ContainerBoxForRestore({super.key, required this.width});

  @override
  State<ContainerBoxForRestore> createState() => _ContainerBoxForRestoreState();
}

class _ContainerBoxForRestoreState extends State<ContainerBoxForRestore> {
  List<BackupModel> backups = [];

  @override
  void initState() {
    super.initState();
    loadBackups();
  }

  Future<void> loadBackups() async {
    try {
      final data = await fetchBackups();
      setState(() {
        backups = data;
      });
    } catch (e) {
      print("Error loading backups: $e");
    }
  }

  Future<Map<String, dynamic>> restoreBackup(String backupFileName) async {
    final url =
        Uri.parse('http://192.168.1.104/database/backup-restore/restore.php');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'backup_file_name': backupFileName}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {"status": "error", "message": "Failed to contact server"};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFF1F7F9),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          width: widget.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Manage Backups",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: DataTable(
                  border: TableBorder.all(
                    color: const Color(0xFF7B8186),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                    (states) => const Color(0xFF064089),
                  ),
                  columns: const [
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        '#',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        'Date',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 550,
                        child: Text(
                          'Available Backups',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        'Version',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(
                        'Actions',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  rows: backups.map((backup) {
                    return DataRow(cells: [
                      DataCell(Text(backup.id.toString())),
                      DataCell(Text(backup.backupDate)),
                      DataCell(Text(backup.backupFileName)),
                      DataCell(Text(
                          "v1.0")), // Customize this if version info exists
                      DataCell(
                        Row(
                          children: [
                            NoBgNoIcon(
                              label: "Restore",
                              onPressed: () async {
                                final backupFileName = backup
                                    .backupFileName; // Get the backup file name
                                final response =
                                    await restoreBackup(backupFileName);

                                // Check response and show appropriate message
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Restore successful!')));
                                  // Optionally reload the backups or data after restore
                                  loadBackups();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Restore failed: ${response['message']}')));
                                }
                              },
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                border:
                                    Border.all(color: const Color(0xFFEF4444)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: IconButton(
                                color: const Color(0xFFEF4444),
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Call delete logic here
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
