import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';

class ExcelToJson {
  Future<String?> convert() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv', 'xls'],
    );

    if (file != null && file.files.isNotEmpty) {
      // Use the bytes directly for web
      Uint8List? bytes = file.files.first.bytes;
      if (bytes != null) {
        var excel = Excel.decodeBytes(bytes);
        int i = 0;
        List<dynamic> keys = <dynamic>[];
        List<Map<String, dynamic>> json = <Map<String, dynamic>>[];

        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table]?.rows ?? []) {
            try {
              if (i == 0) {
                // First row is treated as keys/headers
                keys = row.map((cell) => cell?.value?.toString() ?? '').toList();
                i++;
              } else {
                Map<String, dynamic> temp = <String, dynamic>{};
                for (int j = 0; j < keys.length; j++) {
                  String key = keys[j].isNotEmpty ? keys[j] : 'Column$j';
                  String value = row[j]?.value?.toString() ?? '';
                  temp[key] = value;
                }
                json.add(temp);
              }
            } catch (ex) {
              print("Error processing row: $ex");
              Map<String, dynamic> temp = <String, dynamic>{};
              temp['ExcelStatus'] = 'Error';
              json.add(temp);
            }
          }
        }

        String fullJson = jsonEncode(json);
        return fullJson;
      }
    }
    return null;
  }
}
