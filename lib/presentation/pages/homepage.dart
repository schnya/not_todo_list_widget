import 'package:flutter/material.dart';

import '../../utils/shared_preferences.dart';
import '../widgets/form.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final formKey = GlobalObjectKey<MyFormState>(context);
  int? index;

  Future<void> _incrementCounter() async {
    final prefs = await preferences;
    print(prefs.getString('todo_$index'));
  }

  Future<void> save() async {
    final prefs = await preferences;
    final length = index ?? ((prefs.getInt('length') ?? 0) + 1);
    final text = formKey.currentState?.bodyContoller.text ?? '';

    index ??= length;
    print(index);
    await prefs.setInt('length', index!);
    await prefs.setString('todo_${index!}', text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MyForm(key: formKey, id: index),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: save,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
