import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => MyFormState();
}

class MyFormState extends State<MyForm> {
  final bodyContoller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
  }
}
