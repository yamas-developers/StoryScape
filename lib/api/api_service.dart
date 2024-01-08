import 'dart:developer';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:stories_app/constants.dart';
import 'package:stories_app/routes/session_manager.dart';

class ApiService {
  late http.StreamedResponse _response;
  final dio = Dio();

  Future<File?> downloadFile(String identifier,
      {void Function(int, int)? progressCallback}) async {
    final directory = await getApplicationDocumentsDirectory();

    String url = DownloadBaseUrl + identifier + '.zip';
    log('MK: url: $url');
    final filePath = '${directory.path}/${Uri.parse(url).pathSegments.last}';
    // bool fileExists = await File(filePath).exists();

    final Directory destinationDirectory =
        Directory('${directory.path}/${identifier}');

    bool folderExists = await destinationDirectory.exists();
    if (folderExists) {
      return File(filePath);
    }
    try {
      Response response = await dio.get(url,
          options: Options(responseType: ResponseType.bytes),
          onReceiveProgress: progressCallback);
      log('MK: response status: ${response.statusCode}');

      File file = File(filePath);
      await file.writeAsBytes(response.data as List<int>);

      log('MK: filePath: $filePath and ${await File(filePath).exists()}');

      return file;
    } catch (error) {
      log('MK: Error downloading file: $error');
      return null;
      // rethrow;
    }
    // // final response = await dio.get('https://dart.dev');
    // final response = await http.get(Uri.parse(url));
    //
    // final file = File(filePath);
    // await file.writeAsBytes(response.bodyBytes);
    //
    // return file;
  }

  Future<String> extractZipFile(
      String zipFilePath, String destinationPath) async {
    final File zipFile = File(zipFilePath);
    final directory = await getApplicationDocumentsDirectory();
    final Directory destinationDirectory =
        Directory('${directory.path}/${destinationPath}');

    bool folderExists = await destinationDirectory.exists();

    log('MK: Extracting zip file zipFilePath: ${zipFile.path}');
    log('MK: Extracting zip file destinationDirectory: ${destinationDirectory.path} and exists: $folderExists');
    if (folderExists) return destinationDirectory.path;

    if (!destinationDirectory.existsSync()) {
      destinationDirectory.createSync(recursive: true);
    }

    log('MK: Extracting zip file');
    final Archive archive = ZipDecoder().decodeBytes(zipFile.readAsBytesSync());

    for (final ArchiveFile file in archive) {
      final String filePath = '${destinationDirectory.path}/${file.name}';

      if (file.isFile) {
        final File outFile = File(filePath);
        outFile.createSync(recursive: true);
        outFile.writeAsBytesSync(file.content as List<int>);
      } else {
        final Directory dir = Directory(filePath);
        dir.createSync(recursive: true);
      }
      // zipFile.delete();
    }
    return destinationDirectory.path;
  }

  Future<bool> deleteDirectory(String identifier) async {
    final directory = await getApplicationDocumentsDirectory();
    final Directory destinationDirectory =
        Directory('${directory.path}/${identifier}');

    bool folderExists = await destinationDirectory.exists();

    if (folderExists) {
      await destinationDirectory.delete(recursive: true);
      return true;
    }
    return false;
  }
}
