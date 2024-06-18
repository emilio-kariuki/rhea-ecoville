import 'dart:io';

import 'package:ecoville/data/repository/app_repository.dart';
import 'package:ecoville/models/search_model.dart';
import 'package:ecoville/utilities/packages.dart';

class AppProvider extends AppTemplate {
  final AppRepository _appRepository;
  AppProvider({required AppRepository appRepository})
      : _appRepository = appRepository;

  @override
  Future<File> compressImage({required File image}) {
    return _appRepository.compressImage(image: image);
  }

  @override
  Future<bool> copyToClipboard({required String text}) {
    return _appRepository.copyToClipboard(text: text);
  }

  @override
  Future<void> launchBrowser({required String url}) {
    return _appRepository.launchBrowser(url: url);
  }

  @override
  Future<void> launchEmail({required String email}) {
    return _appRepository.launchEmail(email: email);
  }

  @override
  Future<void> launchMap({required double lat, required double long}) {
    return _appRepository.launchMap(lat: lat, long: long);
  }

  @override
  Future<void> launchPhone({required String phone}) {
    return _appRepository.launchPhone(phone: phone);
  }

  @override
  Future<void> launchShare({required String text, required String subject}) {
    return _appRepository.launchShare(text: text, subject: subject);
  }

  @override
  Future<void> launchSms({required String phone, required String text}) {
    return _appRepository.launchSms(phone: phone, text: text);
  }

  @override
  Future<void> launchWhatsApp({required String phone, required String text}) {
    return _appRepository.launchWhatsApp(phone: phone, text: text);
  }

  @override
  Future<File> pickImage({required ImageSource source}) {
    return _appRepository.pickImage(source: source);
  }

  @override
  Future<String> uploadFile({required String path,}) {
    return _appRepository.uploadFile(path: path);
  }

  @override
  Future<String> downloadAndSaveFile(
      {required String url, required String fileName}) {
    return _appRepository.downloadAndSaveFile(url: url, fileName: fileName);
  }

  @override
  Future<bool> clearSearchList() {
    return _appRepository.clearSearchList();
  }

  @override
  Future<List<SearchModel>> getSearchList() {
    return _appRepository.getSearchList();
  }

  @override
  Future<bool> insertSearch({required String name}) {
    return _appRepository.insertSearch(name: name);
  }
}
