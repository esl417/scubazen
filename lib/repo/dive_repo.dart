import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';

class DiveRepo {
  static final instance = DiveRepo();
  List<Map<String, dynamic>> dummyDiveLogs = [
    {
      'siteName': 'Blue Hole',
      'altitude': 0,
      'vesselShop': 'Ocean Adventures',
      'user': '12345679',
      'ID': 1,
      'Visibility': 30,
      'Note': 'Amazing dive!',
      'day_night': true,
      'salt_fresh': true,
      'shore_boat': false,
      'gasOxygen': 21,
      'tank_type': 'Steel',
      'water_temp': 26,
      'belt_weight': 5,
      'start_pressure': 200,
      'end_pressure': 50,
      'tank_volume': 12,
      'tank_units': 'liters',
      'depth_units': 'meters',
      'pressure_units': 'bar',
      'weight_units': 'kg',
      'rating': 5,
      'air_temp': 25,
      'current': 2,
      'divetime_start': Timestamp.fromDate(DateTime(2023, 6, 10, 9, 0)),
      'divetime_end': Timestamp.fromDate(DateTime(2023, 6, 10, 10, 0)),
      'divedate_start': Timestamp.fromDate(DateTime(2023, 6, 10)),
      'divedate_end': Timestamp.fromDate(DateTime(2023, 6, 10)),
      'max_depth': 30,
      'location_text': 'Belize',
      'suit_thickness': '3mm',
      'total_divetime': '60 mins',
      'weight_adjust': 'None',
      'wetsuit_adjust': 'None',
      'coordinates': '24.396308, -76.638568',
      'nitrogen_percent': 79,
      'helium_percent': 0,
      'deco_time': '15 mins',
      'safety_stop': '3 mins',
      'vis_units': 'meters',
      'temp_units': 'Celsius',
      'deco_gas': false,
      'deco_dive': false,
      'equipment': '12345679',
      'diveType': '12345679',
    },
    {
      'siteName': 'Coral Reef',
      'altitude': 5,
      'vesselShop': 'Dive Masters',
      'user': '12345679',
      'ID': 2,
      'Visibility': 25,
      'Note': 'Beautiful corals!',
      'day_night': false,
      'salt_fresh': true,
      'shore_boat': true,
      'gasOxygen': 21,
      'tank_type': 'Aluminum',
      'water_temp': 24,
      'belt_weight': 6,
      'start_pressure': 180,
      'end_pressure': 60,
      'tank_volume': 11,
      'tank_units': 'liters',
      'depth_units': 'meters',
      'pressure_units': 'bar',
      'weight_units': 'kg',
      'rating': 4,
      'air_temp': 27,
      'current': 3,
      'divetime_start': Timestamp.fromDate(DateTime(2023, 7, 15, 10, 0)),
      'divetime_end': Timestamp.fromDate(DateTime(2023, 7, 15, 11, 0)),
      'divedate_start': Timestamp.fromDate(DateTime(2023, 7, 15)),
      'divedate_end': Timestamp.fromDate(DateTime(2023, 7, 15)),
      'max_depth': 25,
      'location_text': 'Bahamas',
      'suit_thickness': '5mm',
      'total_divetime': '60 mins',
      'weight_adjust': 'None',
      'wetsuit_adjust': 'None',
      'coordinates': '25.761680, -80.191790',
      'nitrogen_percent': 78,
      'helium_percent': 1,
      'deco_time': '10 mins',
      'safety_stop': '3 mins',
      'vis_units': 'meters',
      'temp_units': 'Celsius',
      'deco_gas': true,
      'deco_dive': true,
      'equipment': '12345679',
      'diveType': '12345679',
    }
  ];

  void saveDiveLogsToFirebase(List<Map<String, dynamic>> diveLogs) async {
    final CollectionReference diveLogCollection =
        FirebaseFirestore.instance.collection('diveLog');

    for (var diveLog in diveLogs) {
      await diveLogCollection.add(diveLog);
    }
  }

  Future<void> addImportedListToFirebase(
      List<Map<String, dynamic>> importedList) async {
    try {
      for (var item in importedList) {
        await FirebaseFirestore.instance.collection('diveLog').add(item);
      }
      print('Imported list added to Firebase successfully.');
    } catch (e) {
      print('Error adding imported list to Firebase: $e');
    }
  }

  Future<List<String>> fetchPredefinedHeaders() async {
    List<String> headers = [];
    final querySnapshot =
        await FirebaseFirestore.instance.collection('diveLog').get();
    if (querySnapshot.docs.isNotEmpty) {
      final keys = querySnapshot.docs.first.data().keys;
      headers = keys.toList();

      headers.sort((a, b) {
        if (a == 'siteName') return -1;
        if (b == 'siteName') return 1;
        return a.compareTo(b);
      });
      headers.remove('ID');
      headers.remove('user');
      headers.remove('equipment');
    }
    return headers;
  }

   Future<List<String>> readSelectedFileHeader(
      Uint8List selectedFile, String fileType) async {
    List<String> headers = [];
    String content = utf8.decode(selectedFile);

    if (fileType == 'csv') {
      List<List<dynamic>> rowsAsListOfValues =
          const CsvToListConverter().convert(content);
      headers = List<String>.from(rowsAsListOfValues.first);
    } else if (fileType == 'json') {
      var jsonData = jsonDecode(content);
      if (jsonData is List && jsonData.isNotEmpty && jsonData.first is Map) {
        headers = (jsonData.first as Map<String, dynamic>)
            .keys
            .cast<String>()
            .toList();
      } else if (jsonData is Map) {
        headers =
            (jsonData as Map<String, dynamic>).keys.cast<String>().toList();
      } else {
        throw Exception('Unsupported JSON structure');
      }
    }

    return headers;
  }
}
