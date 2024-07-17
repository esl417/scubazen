import 'dart:convert';
import 'dart:developer';
import 'package:csv_json_import/repo/dive_repo.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:csv/csv.dart';
import 'package:csv_json_import/constant/color_constant.dart';
import 'package:csv_json_import/views/match_header_view.dart';
import 'package:csv_json_import/constant/theme_constant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PickFileView extends StatefulWidget {
  const PickFileView({super.key});

  @override
  State<PickFileView> createState() => _PickFileViewState();
}

class _PickFileViewState extends State<PickFileView> {
  Uint8List? selectedFile;
  String? selectedFileName;
  String? fileType;

  @override
  Widget build(BuildContext context) {
    DiveRepo.instance.saveDiveLogsToFirebase(DiveRepo.instance.dummyDiveLogs);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("CSV And Json Import",
            style: CustomFont.mediumText.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 18)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor),
                    onPressed: () async {
                      await pickFile(context);
                    },
                    child: Text(
                      selectedFileName ?? "Upload CSV / JSON",
                      style:
                          CustomFont.regularText.copyWith(color: Colors.white),
                    )),
              ],
            ),
            const SizedBox(height: 20),
            selectedFile == null
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: newGreenColor,
                            minimumSize: const Size(220, 48),
                          ),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MatchHeaderPage(
                                      selectedFile: selectedFile!,
                                      fileType: fileType ?? '')),
                            );
                          },
                          child: Text(
                            "Matching header Page",
                            style: CustomFont.regularText
                                .copyWith(color: Colors.white),
                          )),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  Future<void> pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['csv', 'json'],
        type: FileType.custom,
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        String fileName = file.name;
        String fileExtension = file.extension ?? '';

        if (fileExtension != 'csv' && fileExtension != 'json') {
          log('Unsupported Document');
        } else {
          Uint8List? fileContent;

          if (kIsWeb) {
            fileContent = file.bytes;
          } else {
            io.File ioFile = io.File(file.path!);
            fileContent = await ioFile.readAsBytes();
          }

          if (fileContent == null) {
            log('File content is null');
            return;
          }

          setState(() {
            selectedFileName = fileName;
            fileType = fileExtension;
            selectedFile = fileContent;
          });
        }
      } else {
        print('No file selected');
      }
    } catch (e) {
      log('Error in pickFile: ${e.toString()}');
    }
  }
}
