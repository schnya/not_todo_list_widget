import 'package:flutter/cupertino.dart';
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

  void openDrawer() => scaffold.currentState?.openDrawer();

  Future<void> save() async {
    final prefs = await preferences;
    final text = formKey.currentState?.bodyContoller.text;
    if (text is! String || text.isEmpty) return;

    if (widget.id == null) {
      await prefs.setInt('length', index!);
      ref.read(numOfTodosStateProvider.state).state = index!;
    }
    await prefs.setString('todo_$index', text);
    print('saved');
  }

  @override
  void initState() {
    super.initState();

    if (widget.id is int) {
      index = widget.id;
    } else {
      setState(() {
        preferences.then((prefs) => index = (prefs.getInt('length') ?? 0) + 1);
      });
    }
    node.requestFocus();
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
        automaticallyImplyLeading: false,
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
      floatingActionButton: node.hasFocus
          ? Row(
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
            )
          : null,
      drawer: MyList(length: index),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              IconData(
                0xf6e8,
                fontFamily: CupertinoIcons.iconFont,
                fontPackage: CupertinoIcons.iconFontPackage,
              ),
            ),
            label: 'list',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              IconData(
                0xf779,
                fontFamily: CupertinoIcons.iconFont,
                fontPackage: CupertinoIcons.iconFontPackage,
              ),
            ),
            label: 'new ToDo',
          ),
        ],
        onTap: (value) {
          if (value == 0) {
            openDrawer();
          } else {
            final text = formKey.currentState?.bodyContoller.text;
            if (text is! String || text.isEmpty) return;

            setState(() => index = ref.read(numOfTodosStateProvider) + 1);
            node.requestFocus();
          }
        },
      ),
    );
  }
}
