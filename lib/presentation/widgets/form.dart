import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key, this.id, required this.node});

  final int? id;
  final FocusNode node;

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
  void didUpdateWidget(MyForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    preferences.then((prefs) {
      final value = prefs.getString('todo_${widget.id}') ?? '';
      bodyContoller.text = value;
    });
  }

  @override
  void dispose() {
    bodyContoller.dispose();
    super.dispose();
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
            focusNode: widget.node,
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
            keyboardType: TextInputType.multiline,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            maxLines: null,
          ),
        );
      },
    );
  }
}
