import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_todo_list_widget/presentation/pages/view.dart';
import 'package:not_todo_list_widget/utils/utils.dart';

class MyList extends ConsumerWidget {
  const MyList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void navigate(int index) {
      // 遷移がキモい。
      // Navigator.of(context).replaceRouteBelow<dynamic>(
      //   anchorRoute: MyList.route(),
      //   newRoute: MyHomePage.route(index: index),
      // );

      Navigator.of(context).pushAndRemoveUntil<dynamic>(
        MyHomePage.route(index: index),
        (route) => route.isFirst,
      );
    }

    return Drawer(
      child: SafeArea(
          child: ListView.builder(
        itemCount: ref.read<int?>(numOfTodosStateProvider),
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder<String?>(
            future: preferences.then((p) => p.getString('todo_$index')),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();

              return ListTile(
                title: Text(snapshot.data!),
                onTap: () => navigate(index),
              );
            },
          );
        },
      )),
    );
  }
}
