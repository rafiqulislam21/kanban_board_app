import 'package:get_storage/get_storage.dart';

class LocalStorageUtil {

  static write(String key, var value) async {
    final instance = GetStorage();
    return await instance.write(key, value);
  }

  static writeIfNull(String key, var value) async {
    final instance = GetStorage();
    return await instance.writeIfNull(key, value);
  }

  static writeInMemory(String key, var value) async {
    final instance = GetStorage();
    return instance.writeInMemory(key, value);
  }

  static hasData(String key) async {
    final instance = GetStorage();
    return instance.hasData(key);
  }

  static read(String key) async {
    final instance = GetStorage();
    return await instance.read(key);
  }

  static remove(String key) async {
    final instance = GetStorage();
    return await instance.remove(key);
  }

  static erase() async {
    final instance = GetStorage();
    return await instance.erase();
  }

  static getKeys() async {
    final instance = GetStorage();
    return await instance.getKeys();
  }

  static getValues() async {
    final instance = GetStorage();
    return await instance.getValues();
  }
}
