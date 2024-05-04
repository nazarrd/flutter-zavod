import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class LocalStorageService extends ChangeNotifier {
  SharedPreferences? _prefsInstance;

  LocalStorageService() {
    _init();
  }

  Future<void> _init() async {
    _prefsInstance = await SharedPreferences.getInstance();
    getIt.signalReady(this);
  }

  Future<void> clear() async {
    _prefsInstance?.clear();
  }

  Future<void> remove(String key) async {
    _prefsInstance?.remove(key);
  }

  String? getString(String key) {
    return _prefsInstance?.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    return _prefsInstance?.setString(key, value) ?? Future.value(false);
  }

  int getInt(String key) {
    return _prefsInstance?.getInt(key) ?? 0;
  }

  Future<bool> setInt(String key, int value) async {
    return _prefsInstance?.setInt(key, value) ?? Future.value(false);
  }

  double getDouble(String key) {
    return _prefsInstance?.getDouble(key) ?? 0;
  }

  Future<bool> setDouble(String key, double value) async {
    return _prefsInstance?.setDouble(key, value) ?? Future.value(false);
  }

  bool getBool(String key, [bool defaultValue = false]) {
    return _prefsInstance?.getBool(key) ?? defaultValue;
  }

  Future<bool> setBool(String key, bool value) async {
    return _prefsInstance?.setBool(key, value) ?? Future.value(false);
  }

  List getList(String key) {
    final searchHistory = getString(key);
    List historyList = [];
    if (searchHistory != null) {
      historyList = jsonDecode(searchHistory);
    }
    return historyList;
  }

  Future<bool> setList(String key, String value) async {
    final searchHistory = getString(key);
    List historyList = [];
    if (searchHistory != null) {
      historyList = jsonDecode(searchHistory);
      if (!historyList.contains(value)) historyList.add(value);
    } else {
      historyList.add(value);
    }
    final status = await setString(key, jsonEncode(historyList));
    debugPrint('$value added to list. current list data: ${getString(key)}');
    return status;
  }
}
