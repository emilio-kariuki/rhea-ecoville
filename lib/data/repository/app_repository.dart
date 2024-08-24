import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:dio/dio.dart';
import 'package:ecoville/data/local/local_database.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/search_model.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract class AppTemplate {
  Future<File> pickImage({required ImageSource source});
  Future<File> compressImage({required File image});
  Future<String> uploadFile({
    required String path,
  });
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
  Future<List<SearchModel>> getSearchList();
  Future<bool> clearSearchList();
  Future<bool> insertSearch({required String name});
}

class AppRepository extends AppTemplate {
  final _dbHelper = service<DatabaseHelper>();
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
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
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
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint('Error launching broswer $e');
    }
  }

  @override
  Future<void> launchMap({required double lat, required double long}) async {
    try {
      final intent = AndroidIntent(
          action: 'action_view',
          data: 'google.navigation:q=$lat,$long',
          // data: Uri.encodeFull(
          //     'google.navigation:q=Taronga+Zoo,+Sydney+Australia&avoid=tf'),
          package: 'com.google.android.apps.maps');
      intent.launch();
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint('Error launching broswer $e');
    }
  }

  @override
  Future<void> launchPhone({required String phone}) async {
    try {
      final phoneUrl = 'tel:$phone';
       await launchUrl(Uri.parse(phoneUrl));
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
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
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
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
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint('Error launching broswer $e');
    }
  }

  @override
  Future<void> launchWhatsApp(
      {required String phone, required String text}) async {
    try {
      await launchWhatsApp(phone: phone, text: text);
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
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
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint(e.toString());
      throw Exception('Error picking image');
    }
  }

  @override
  Future<String> uploadFile({required String path}) async {
    try {
      File image = File(path);
      final id = supabase.auth.currentUser!.id;
      final imageKey =
          'images/$id/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final compressedImage = await compressImage(image: image);
      
      await supabase.storage.from('ecoville').upload(
            imageKey,
            compressedImage,
            retryAttempts: 3,
            
          );
          
      final url = supabase.storage.from('ecoville').getPublicUrl(imageKey);
      debugPrint("The image has been inserted");
      return url;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint(e.toString());
      throw Exception('Error uploading image');
    }
  }

  @override
  Future<String> downloadAndSaveFile(
      {required String url, required String fileName}) async {
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

  @override
  Future<List<SearchModel>> getSearchList() async {
    try {
      final db = await _dbHelper.init();
      final searches = await db.query(LOCAL_TABLE_SEARCH);
      return searches.map((e) => SearchModel.fromJson(e)).toList();
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint(e.toString());
      throw Exception('Error getting search list');
    }
  }

  @override
  Future<bool> clearSearchList() async {
    try {
      final db = await _dbHelper.init();
      await db.delete(LOCAL_TABLE_SEARCH);
      return true;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint(e.toString());
      throw Exception('Error getting search list');
    }
  }

  @override
  Future<bool> insertSearch({required String name}) async {
    try {
      final db = await _dbHelper.init();
      db.insert(LOCAL_TABLE_SEARCH, {'id': const Uuid().v4(), 'name': name});
      return true;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint(e.toString());
      throw Exception('Error inserting search');
    }
  }
}
