import 'package:database/database/app_cubit.dart';
import 'package:database/database/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksScreen extends StatelessWidget {
  late BuildContext context;

  Widget build(BuildContext context) {
    this.context = context;
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return AppCubit.get(context).tasks.isEmpty
            ? buildEmptyDesign()
            : Container(
                padding: EdgeInsets.all(10),
                child: ListView.separated(
                  itemBuilder: (context, index) =>
                      buildTaskItem(cubit.tasks[index]),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  ),
                  itemCount: cubit.tasks.length,
                ),
              );
      },
    );
  }

  Widget buildTaskItem(Map<dynamic, dynamic> task) {
    return Dismissible(
      key: Key(task['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteTasks(id: task['id']);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${task['title']}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    AppCubit.get(context).updateTask(
                      status: "done",
                      id: task['id'],
                    );
                  },
                  icon: Icon(
                    Icons.done_outline,
                    color: Colors.green,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    AppCubit.get(context).updateTask(
                      status: "archive",
                      id: task['id'],
                    );
                  },
                  icon: Icon(
                    Icons.archive_outlined,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date ${task['date']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                Text(
                  'Time ${task['time']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyDesign() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_outlined,size: 70,color: Colors.blue,),
          Text(
            "No Tasks",
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }
}