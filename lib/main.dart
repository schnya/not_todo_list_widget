import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/pages/view.dart';
import 'utils/utils.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<int?> fetchNumOfTodos() {
      return preferences.then((pref) {
        final num = pref.getInt('length') ?? 0;
        print('現在のToDoの数: $num');
        ref.read(numOfTodosStateProvider.state).state = num;
        return num;
      });
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: FutureBuilder<int?>(
        future: fetchNumOfTodos(),
        builder: (context, snapshot) => const MyHomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
