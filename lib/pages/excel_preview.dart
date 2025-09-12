import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

class ExcelPreviewPage extends StatefulWidget {
  final PlatformFile file;
  const ExcelPreviewPage({super.key, required this.file});

  @override
  State<ExcelPreviewPage> createState() => _ExcelPreviewPageState();
}

class _ExcelPreviewPageState extends State<ExcelPreviewPage> {
  List<List<dynamic>> excelData = [];
  List<Map<String, dynamic>> jsonData = [];
  List<String> headers = [];

  @override
  void initState() {
    super.initState();
    loadExcel();
  }

  void loadExcel() async {
    if (widget.file.bytes != null) {
      var bytes = widget.file.bytes!;
      var excel = Excel.decodeBytes(bytes);

      List<List<dynamic>> rows = [];

      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          List<dynamic> cleanRow = [];
          for (var cell in row) {
            cleanRow.add(cell?.value?.toString() ?? '');
          }
          rows.add(cleanRow);
        }
      }

      // Convert to JSON format
      List<Map<String, dynamic>> jsonRows = [];
      List<String> columnHeaders = [];
      
      if (rows.isNotEmpty) {
        // First row as headers
        columnHeaders = rows[0].map((e) => e.toString()).toList();
        
        // Convert remaining rows to JSON objects
        for (int i = 1; i < rows.length; i++) {
          Map<String, dynamic> rowObject = {};
          for (int j = 0; j < columnHeaders.length && j < rows[i].length; j++) {
            rowObject[columnHeaders[j]] = rows[i][j];
          }
          jsonRows.add(rowObject);
        }
      }

      setState(() {
        excelData = rows;
        headers = columnHeaders;
        jsonData = jsonRows;
      });
    }
  }

  Future<void> uploadToDatabase() async {
    // Convert data to JSON format for API
    String jsonString = jsonEncode(jsonData);
    print('JSON Data to upload: $jsonString');
    
    // TODO: Call your API to upload the jsonData
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("File uploaded to database successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview Data"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: excelData.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: headers.map((header) => DataColumn(
                          label: Text(
                            header,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )).toList(),
                        rows: jsonData.map((rowData) => DataRow(
                          cells: headers.map((header) => DataCell(
                            Text(rowData[header]?.toString() ?? ''),
                          )).toList(),
                        )).toList(),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              onPressed: uploadToDatabase,
              icon: const Icon(Icons.cloud_upload),
              label: const Text("Upload to Database"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
