import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_todo_list_widget/presentation/widgets/lists.dart';

import '../../utils/utils.dart';
import '../widgets/form.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, this.id});

  final int? id;

  static Route<void> route({int? index}) {
    return MaterialPageRoute<void>(
      builder: (context) => MyHomePage(id: index),
    );
  }

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  late final scaffold = GlobalObjectKey<ScaffoldState>(context);
  late final formKey = GlobalObjectKey<MyFormState>(context);
  final node = FocusNode();
  int? index;

  Future<void> save() async {
    final prefs = await preferences;
    final text = formKey.currentState?.bodyContoller.text;
    if (text is! String || text.isEmpty) return;

    if (widget.id == null) {
      // 新規作成
      await prefs.setInt('length', index! + 1);
      ref.read(numOfTodosStateProvider.state).state = index! + 1;
    }
    await prefs.setString('todo_$index', text);
    print('saved');

    node.unfocus();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    if (widget.id is int) {
      index = widget.id;
    } else {
      setState(() {
        preferences
            .then((prefs) => index = prefs.getInt('length') ?? 0)
            .whenComplete(() => print(index));
      });
      node.requestFocus();
    }
  }

  @override
  void dispose() {
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final text = formKey.currentState?.bodyContoller.text;
              if (text is! String || text.isEmpty) return;

              setState(() => index = ref.read(numOfTodosStateProvider) + 1);
              node.requestFocus();
            },
            icon: const Icon(Icons.add),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MyForm(key: formKey, node: node, id: index),
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              node.unfocus();
              setState(() {});
            },
            child: const Icon(Icons.close),
          )
        ],
      ),
      drawer: const MyList(),
    );
  }
}
