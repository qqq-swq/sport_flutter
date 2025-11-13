import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:sport_flutter/data/datasources/sts_remote_data_source.dart';

class OssUploadService {
  final StsRemoteDataSource stsDataSource;
  final Dio dio;

  OssUploadService({required this.stsDataSource, required this.dio});

  Future<String> uploadFile(File file) async {
    try {
      print("--- 1. Starting OSS Upload ---");
      final credentials = await stsDataSource.getOssCredentials();
      print("--- 2. Got STS Credentials ---");

      final String fileName = path.basename(file.path);
      final String extension = path.extension(file.path).toLowerCase();

      String uploadFolder;
      if (['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(extension)) {
        uploadFolder = 'videos/communityimage';
      } else if (['.mp4', '.mov', '.avi', '.mkv', '.flv', '.wmv'].contains(extension)) {
        uploadFolder = 'videos/communityvideos';
      } else {
        uploadFolder = 'videos/others'; 
      }

      final String objectKey = '$uploadFolder/${DateTime.now().millisecondsSinceEpoch}-$fileName';
      final String host = '${credentials.bucket}.${credentials.region}.aliyuncs.com';
      final String fileUrl = 'https://$host/$objectKey';

      final String date = HttpDate.format(DateTime.now().toUtc());
      final String contentType = 'application/octet-stream';

      final List<String> parts = [
        'PUT',
        '', // Content-MD5
        contentType,
        date,
        'x-oss-security-token:${credentials.securityToken}',
        '/${credentials.bucket}/$objectKey'
      ];
      final String stringToSign = parts.join('\n');

      print("--- 3. Preparing to Sign ---");
      print("String to Sign:\n--BEGIN--\n$stringToSign\n--END--");

      final key = utf8.encode(credentials.accessKeySecret);
      final hmac = Hmac(sha1, key);
      final digest = hmac.convert(utf8.encode(stringToSign));
      final signature = base64.encode(digest.bytes);

      print("--- 4. Signature Calculated ---");

      await dio.put(
        'https://$host/$objectKey',
        data: file.openRead(),
        options: Options(
          headers: {
            'Host': host,
            'Content-Type': contentType,
            'Content-Length': await file.length(),
            'Date': date,
            'x-oss-security-token': credentials.securityToken,
            'Authorization': 'OSS ${credentials.accessKeyId}:$signature',
          },
        ),
      );

      print("--- 5. Upload Successful ---");
      // Reverted: Return the full URL to align with the new backend logic.
      return fileUrl;

    } catch (e) {
      print('---!!! UPLOAD FAILED !!!---');
      if (e is DioException && e.response != null) {
        print('OSS Error Status: ${e.response!.statusCode}');
        print('OSS Error Headers: ${e.response!.headers}');
        print('OSS Error Body: ${e.response!.data}');
      } else {
        print('An unexpected error occurred: $e');
      }
      rethrow;
    }
  }
}
