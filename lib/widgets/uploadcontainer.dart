import 'package:crm_app/pages/excel_preview.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';



class UploadContainer extends StatefulWidget {
  const UploadContainer({super.key});

  @override
  State<UploadContainer> createState() => _UploadContainerState();
}

class _UploadContainerState extends State<UploadContainer> {
  PlatformFile? selectedFile;

  Future<void> pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      setState(() {
        selectedFile = result.files.single;
      });

      // Navigate to preview page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ExcelPreviewPage(file: selectedFile!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
          onTap: pickExcelFile,
          child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.upload_file, size: 50, color: Colors.blue[600]),
                const SizedBox(height: 10),
                const Text(
                  "Upload your customer data here",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  "Let us parse your customer data and create segments for you",
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),);
   
  }
}
