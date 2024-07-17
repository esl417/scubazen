import 'package:csv_json_import/model/dive_log_model.dart';
import 'package:csv_json_import/constant/theme_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class KeyValueList extends StatelessWidget {
  final Map<String, dynamic> data;

  const KeyValueList({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries
          .map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${entry.key}:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('${entry.value}'),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class ImportedListView extends StatefulWidget {
  final List<Map<String, dynamic>> importedList;

  const ImportedListView({Key? key, required this.importedList})
      : super(key: key);

  @override
  State<ImportedListView> createState() => _ImportedListViewState();
}

class _ImportedListViewState extends State<ImportedListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Imported List",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 18)),
      ),
      body: ListView.builder(
        itemCount: widget.importedList.length,
        itemBuilder: (context, index) {
          final item = widget.importedList[index];
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              margin: const EdgeInsets.all(8.0),
              elevation: 5,
              child: ListTile(
                title: Text('${index+1}'),
                subtitle: KeyValueList(data: item),
              ),
            ),
          );
        },
      ),
    );
  }
}
