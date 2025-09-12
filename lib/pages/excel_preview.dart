import 'package:crm_app/bloc/data_ingestion_bloc.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          rows.add(row.map((cell) => cell?.value?.toString() ?? '').toList());
        }
      }

      List<Map<String, dynamic>> jsonRows = [];
      List<String> columnHeaders = [];

      if (rows.isNotEmpty) {
        columnHeaders = rows[0].map((e) => e.toString()).toList();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Excel Data Preview",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: BlocListener<DataIngestionBloc, DataIngestionState>(
        listener: (context, state) {
          if (state is DataIngestionSuccess) {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text("✅ Success"),
                    content: const Text("Data uploaded successfully!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
            );
          } else if (state is DataIngestionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("❌ Error: ${state.error}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child:
                  excelData.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(
                                Colors.blue.shade50,
                              ),
                              columns:
                                  headers
                                      .map(
                                        (header) => DataColumn(
                                          label: Text(
                                            header,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              rows:
                                  jsonData
                                      .map(
                                        (rowData) => DataRow(
                                          cells:
                                              headers
                                                  .map(
                                                    (header) => DataCell(
                                                      Text(
                                                        rowData[header]
                                                                ?.toString() ??
                                                            '',
                                                        style: const TextStyle(
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                        ),
                      ),
            ),
            if (jsonData.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${jsonData.length} records ready for upload",
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            BlocBuilder<DataIngestionBloc, DataIngestionState>(
              builder: (context, state) {
                if(state is DataIngestionLoading){
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<DataIngestionBloc>().add(
                        UploadFileEvent(jsonData),
                      );
                    },
                    icon: const Icon(Icons.cloud_upload, size: 22),
                    label: const Text(
                      "Upload to Database",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
