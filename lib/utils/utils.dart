import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
final numOfTodosStateProvider = StateProvider<int>((ref) => 0);
