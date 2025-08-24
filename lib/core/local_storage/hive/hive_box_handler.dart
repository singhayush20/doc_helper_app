import 'package:hive/hive.dart';

class HiveBoxHandler {
  HiveBoxHandler({required this.appStorageBox});

  final Box<dynamic> appStorageBox;

  Future<void> clear() async {
    await appStorageBox.clear();
  }
}
