import 'dart:developer';

import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart' as path;

class MyDrive {
  static DriveApi drive;
  static const mimeTypeFolder = 'application/vnd.google-apps.folder';
  MyDrive(Client client) {
    final drive = DriveApi(client);
    print('drive instantiated ' + client.toString());
    MyDrive.drive = drive;
  }

  static Future<List<File>> driveFiles({fileId, showAllFiles = false}) async {
    log('getting drive files...');

    var files;
    final q = showAllFiles ? null : "'$fileId' in parents";
    try {
      if (fileId != null) {
        files = await drive.files.list(
          // driveId: fileId,
          q: q,
          $fields: '*',
          supportsAllDrives: true,
          includeItemsFromAllDrives: true,
          // corpora: 'drive',
          // supportsAllDrives: true,
        );
        return files.files;
      }
      files = await drive.files.list(
        q: showAllFiles ? null : "mimeType='application/vnd.google-apps.folder'",
        $fields: '*',
      );
      return files.files;
    } catch (e) {
      log('getting drive files error: $e');

      rethrow;
    }
  }

  static Future<About> getDriveStorageQuota() async {
    log('getting storage quota...');

    try {
      final about = await drive.about.get($fields: '*');
      return about;
    } catch (e) {
      log('error during getting storage quota: $e');
      rethrow;
    }
  }

  static Future<Media> downloadGoogleDriveFile(String fName, String gdID) async {
    final Media file = await drive.files.get(
      gdID,
      downloadOptions: DownloadOptions.fullMedia,
    );

    return file;
  }

  static void uploadFileToGoogleDrive(io.File file) async {
    var fileToUpload = File();
    fileToUpload.name = path.basename(file.absolute.path);
    final media = Media(file.openRead(), file.lengthSync());
    var response = await drive.files.create(fileToUpload, uploadMedia: media);
    print(response);
  }

  static Future<File> createDir(io.Directory dir) async {
    var file = File();
    file.mimeType = mimeTypeFolder;
    file.name = path.basename(dir.path);
    final createdFile = await drive.files.create(file);
    return createdFile;
  }
}
