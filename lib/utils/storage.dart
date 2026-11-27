import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entry.dart';

const _key = 'entries';

Future<void> saveEntries(List<Entry> entries) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonList = entries.map((e) => jsonEncode(e.toJson())).toList();
  await prefs.setStringList(_key, jsonList);
}

Future<List<Entry>> loadEntries() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonList = prefs.getStringList(_key) ?? [];
  return jsonList
      .map((s) => Entry.fromJson(jsonDecode(s) as Map<String, dynamic>))
      .toList();
}

