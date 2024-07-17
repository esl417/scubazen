import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:csv_json_import/constant/color_constant.dart';
import 'package:csv_json_import/repo/dive_repo.dart';
import 'package:csv_json_import/views/imported_list_view.dart';
import 'package:csv_json_import/constant/theme_constant.dart';
import 'package:flutter/material.dart';

class MatchHeaderPage extends StatefulWidget {
  final Uint8List selectedFile;
  final String fileType;
  const MatchHeaderPage(
      {super.key, required this.selectedFile, required this.fileType});

  @override
  State<MatchHeaderPage> createState() => _MatchHeaderPageState();
}

class _MatchHeaderPageState extends State<MatchHeaderPage> {
  List<String> _fileHeaders = [];
  Map<String, String?> _headerMatches = {};
  final Set<String> _invalidHeaders = {};
  List<String> predefinedHeaders = [];

  @override
  void initState() {
    super.initState();
    _initializeHeaders();
  }

  Future<void> _initializeHeaders() async {
    try {
      final diveRepo = DiveRepo.instance;
      predefinedHeaders = await diveRepo.fetchPredefinedHeaders();
      _fileHeaders = await diveRepo.readSelectedFileHeader(
          widget.selectedFile, widget.fileType);

      setState(() {
        _headerMatches = {for (var header in predefinedHeaders) header: null};
      });
    } catch (e) {
      log('Error initializing headers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CSV And Json Import",
            style: CustomFont.mediumText.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 18)),
      ),
      body: predefinedHeaders.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _fileHeaders.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pre-defined Headers diveLog",
                        style: CustomFont.regularText
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Text(predefinedHeaders.join(', ')),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: predefinedHeaders.length,
                          itemBuilder: (context, index) {
                            String predefinedHeader = predefinedHeaders[index];
                            bool isInvalid =
                                _invalidHeaders.contains(predefinedHeader);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(predefinedHeader,
                                    style: CustomFont.regularText.copyWith(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                      color: isInvalid
                                          ? Colors.red.shade100
                                          : backgroundColor,
                                      border:
                                          Border.all(color: backgroundColor)),
                                  child: DropdownButtonFormField<String?>(
                                    elevation: 0,
                                    autofocus: false,
                                    dropdownColor:
                                        isInvalid ? Colors.red.shade100 : null,
                                    iconEnabledColor: Colors.grey,
                                    isExpanded: true,
                                    iconSize: 30,
                                    value: _headerMatches[predefinedHeader],
                                    items: [
                                      const DropdownMenuItem<String?>(
                                          value: null,
                                          child: Text(
                                            'Select header',
                                            style: CustomFont.lightText,
                                          )),
                                      ..._fileHeaders.map((header) {
                                        return DropdownMenuItem<String>(
                                          value: header,
                                          child: Text(
                                            header,
                                            style: CustomFont.lightText,
                                          ),
                                        );
                                      }),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _headerMatches[predefinedHeader] =
                                            value;
                                      });
                                    },
                                    style: TextStyle(
                                      color:
                                          isInvalid ? Colors.red : Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          if (_validateSelections()) {
            List<Map<String, dynamic>> list = _submitSelections();
            if (list.isNotEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImportedListView(
                      importedList: list,
                    ),
                  ));
            }
          }
        },
        child: Text(
          'Submit',
          style: CustomFont.regularText.copyWith(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
        ),
      ),
    );
  }

  bool _validateSelections() {
    _invalidHeaders.clear();
    Set<String> selectedHeaders = {};
    for (var entry in _headerMatches.entries) {
      if (entry.value != null && !selectedHeaders.add(entry.value!)) {
        _invalidHeaders.add(entry.key);
      }
    }

    if (_invalidHeaders.isNotEmpty) {
      setState(() {});
      return false;
    }
    return true;
  }

  List<Map<String, dynamic>> _submitSelections() {
    List<Map<String, dynamic>> extractedData = [];

    if (widget.fileType == 'csv') {
      String content = utf8.decode(widget.selectedFile);
      List<List<dynamic>> rowsAsListOfValues =
          const CsvToListConverter().convert(content);

      List<String> headers = List<String>.from(rowsAsListOfValues.first);

      for (int i = 1; i < rowsAsListOfValues.length; i++) {
        Map<String, dynamic> row = {};
        for (var predefinedHeader in predefinedHeaders) {
          String? matchedHeader = _headerMatches[predefinedHeader];
          if (matchedHeader != null) {
            int headerIndex = headers.indexOf(matchedHeader);
            if (headerIndex != -1) {
              row[predefinedHeader] = _parseValue(
                  predefinedHeader,
                  rowsAsListOfValues[i][headerIndex] ??
                      _getDefaultForHeader(predefinedHeader));
            } else {
              row[predefinedHeader] = _getDefaultForHeader(predefinedHeader);
            }
          } else {
            row[predefinedHeader] = _getDefaultForHeader(predefinedHeader);
          }
        }
        extractedData.add(row);
      }
    } else if (widget.fileType == 'json') {
      String content = utf8.decode(widget.selectedFile);
      List<dynamic> jsonData = jsonDecode(content);

      for (var item in jsonData) {
        Map<String, dynamic> row = {};
        for (var predefinedHeader in predefinedHeaders) {
          String? matchedHeader = _headerMatches[predefinedHeader];
          if (matchedHeader != null && item.containsKey(matchedHeader)) {
            row[predefinedHeader] = _parseValue(predefinedHeader,
                item[matchedHeader] ?? _getDefaultForHeader(predefinedHeader));
          } else {
            row[predefinedHeader] = _getDefaultForHeader(predefinedHeader);
          }
        }
        extractedData.add(row);
      }
    }
    return extractedData;
  }

  dynamic _parseValue(String header, dynamic value) {
    const intDefaults = [
      'altitude',
      'id',
      'visibility',
      'nitrogenPercent',
      'heliumPercent',
      'gasOxygen',
      'waterTemp',
      'beltWeight',
      'startPressure'
    ];
    const boolDefaults = [
      'dayNight',
      'saltFresh',
      'shoreBoat',
      'decoGas',
      'decoDive'
    ];

    if (intDefaults.contains(header)) {
      return int.tryParse(value.toString()) ?? 0;
    } else if (boolDefaults.contains(header)) {
      return value.toString().toLowerCase() == 'true';
    } else {
      return value;
    }
  }

  dynamic _getDefaultForHeader(String header) {
    const stringDefaults = [
      'siteName',
      'vesselShop',
      'user',
      'note',
      'coordinates',
      'deco_time',
      'safety_stop',
      'vis_units',
      'temp_units',
      'equipment',
      'diveType'
    ];
    const intDefaults = [
      'altitude',
      'ID',
      'Visibility',
      'nitrogen_percent',
      'helium_percent',
      'gasOxygen',
      'water_temp',
      'belt_weight',
      'start_pressure',
      'end_pressure',
      'tank_volume',
      'rating',
      'air_temp',
      'current',
      'max_depth'
    ];
    const boolDefaults = [
      'day_night',
      'salt_fresh',
      'shore_boat',
      'deco_gas',
      'deco_dive'
    ];
    const dateTimeDefaults = [
      'divetime_start',
      'divetime_end',
      'divedate_start',
      'divedate_end'
    ];

    if (stringDefaults.contains(header)) {
      return 'no data';
    } else if (intDefaults.contains(header)) {
      return 0;
    } else if (boolDefaults.contains(header)) {
      return false;
    } else if (dateTimeDefaults.contains(header)) {
      return '00:00';
    } else {
      return 'no data';
    }
  }
}
