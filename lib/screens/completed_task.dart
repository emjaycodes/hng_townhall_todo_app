import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/components/custom_text.dart';
import '../app/constants/app_color.dart';
import '../app/providers/todo_provider.dart';

class TaskCompletedScreen extends StatelessWidget {
  const TaskCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoNotifier>(
      builder: (context, todoNotifier, child) {
        final completedTasks = todoNotifier.todoList.where((task) => task['todoIsCompleted'] == true).toList();

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: AppColor.textColor,
            title: const CustomText(requiredText: 'Done To-do', color: AppColor.textColor,),
          ),
          body: completedTasks.isEmpty
              ? const Center(
                  child: Text("No completed tasks yet."),
                )
              : ListView.builder(
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 0, right: 5, bottom: 5),
                        child: Image.asset('assets/png/checked.png'),
                      ),
                      title: Text(
                        completedTasks[index]['todoName'],
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    );
                  },
                ),
        );
      },
    );
  }
}
