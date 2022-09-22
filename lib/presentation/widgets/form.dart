import 'package:flutter/material.dart';

import '../../utils/shared_preferences.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key, this.id});

  final int? id;

  @override
  State<MyForm> createState() => MyFormState();
}

class MyFormState extends State<MyForm> {
  late final TextEditingController bodyContoller;
  late final Future<String> initialValue;

  @override
  void initState() {
    super.initState();
    initialValue = preferences.then((prefs) {
      final value = prefs.getString('todo_${widget.id}') ?? '';
      bodyContoller = TextEditingController(text: value);
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: initialValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        return Expanded(
          child: TextFormField(
            controller: bodyContoller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
            keyboardType: TextInputType.multiline,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            autofocus: true,
            maxLines: null,
          ),
        );
      },
    );
  }
}
