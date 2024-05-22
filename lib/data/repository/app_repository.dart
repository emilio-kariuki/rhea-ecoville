import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:flutter/services.dart';

abstract class AppTemplate {
  Future<File> pickImage({required ImageSource source});
  Future<File> compressImage({required File image});
  Future<String> uploadFile({required String path, required String productId});
  Future<void> launchPhone({required String phone});
  Future<void> launchEmail({required String email});
  Future<void> launchBrowser({required String url});
  Future<void> launchMap({required double lat, required double long});
  Future<void> launchShare({required String text, required String subject});
  Future<void> launchSms({required String phone, required String text});
  Future<void> launchWhatsApp({required String phone, required String text});
  Future<bool> copyToClipboard({required String text});
  Future<String> downloadAndSaveFile(
      {required String url, required String fileName});
}

class AppRepository extends AppTemplate {
  @override
  Future<File> compressImage({required File image}) async {
    try {
      final filePath = image.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp('.jp|png'));
      final split = filePath.substring(0, lastIndex);
      final outPath = '${split}_out${filePath.substring(lastIndex)}';
      final result = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path,
        outPath,
        quality: 40,
      );
      return File(result!.path);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error compressing image');
    }
  }

  @override
  Future<bool> copyToClipboard({required String text}) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      return true;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception('Error copying to clipboard');
    }
  }

  @override
  Future<void> launchEmail({required String email}) async {
    try {
      final emailUrl = 'mailto:$email';
      await launchUrl(Uri.parse(emailUrl));
    } catch (e) {
      debugPrint('Error launching broswer $e');
    }
  }

  @override
  Future<void> launchMap({required double lat, required double long}) async {
    try {
      final mapUrl =
          'https://www.google.com/maps/search/?api=1&query=$lat,$long';
      await launchUrl(Uri.parse(mapUrl));
    } catch (e) {
      debugPrint('Error launching broswer $e');
    }
  }

  @override
  Future<void> launchPhone({required String phone}) async {
    try {
      final phoneUrl = 'tel:$phone';
      await launchUrl(Uri.parse(phoneUrl));
    } catch (e) {
      debugPrint('Error launching broswer $e');
    }
  }

  @override
  Future<void> launchShare(
      {required String text, required String subject}) async {
    try {
      await Share.share(text, subject: subject);
    } catch (error) {
      debugPrint(error.toString());
      throw Exception('Error copying to clipboard');
    }
  }

  @override
  Future<void> launchSms({required String phone, required String text}) async {
    try {
      await launchSms(phone: phone, text: text);
    } catch (e) {
      debugPrint('Error launching Sms $e');
    }
  }

  @override
  Future<void> launchBrowser({required String url}) async {
    try {
      final browserUrl = Uri.parse(url);

      await launchUrl(
        browserUrl,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('Error launching broswer $e');
    }
  }

  @override
  Future<void> launchWhatsApp(
      {required String phone, required String text}) async {
    try {
      await launchWhatsApp(phone: phone, text: text);
    } catch (e) {
      debugPrint('Error launching whatsapp $e');
    }
  }

  @override
  Future<File> pickImage({required ImageSource source}) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
      );
      final file = await compressImage(image: File(pickedFile!.path));
      return file;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error picking image');
    }
  }

  @override
  Future<String> uploadFile(
      {required String path, required String productId}) async {
    try {
      File image = File(path);
      final id = supabase.auth.currentUser!.id;
      final imageKey =
          'images/$id/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final compressedImage = await compressImage(image: image);
      await supabase.storage.from(TABLE_BUCKET).upload(
            imageKey,
            compressedImage,
            retryAttempts: 3,
          );
      final url = supabase.storage.from(TABLE_BUCKET).getPublicUrl(imageKey);
      await supabase.from(TABLE_IMAGES).upsert(
        {
          'id': "$productId${DateTime.now().millisecondsSinceEpoch.toString()}",
          'name': imageKey,
          'url': url,
          'userId': supabase.auth.currentUser!.id,
          'productId': productId,
        },
      );
      debugPrint("The image has been inserted");
      return url;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error uploading image');
    }
  }

  @override
  Future<String> downloadAndSaveFile({required String url, required String fileName}) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    final File file = File(filePath);
    await file.writeAsBytes(response.data);
    return filePath;
  }
}
