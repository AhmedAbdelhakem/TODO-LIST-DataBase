import 'package:bloc/bloc.dart';
import 'package:database/database/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../navigator/tasks_navigator_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit(AppStates initialState) : super(initialState);

  static AppCubit get(context) => BlocProvider.of(context);

  int position = 0;

  late Database database;

  List<Map> tasks = [];

  var title = [
    'Tasks',
    'Done',
    'Archive',
  ];

  var screens = [
    TasksScreen(),
    TasksScreen(),
    TasksScreen(),
    // DoneNavigatorScreen(),
    // ArchiveNavigatorScreen(),
  ];

  void onBottomNavigationChange(int value) {
    position = value;
    emit(AppBottomNavigationBarState());
  }

  createDatabase() async {
    database =
        await openDatabase("todo", version: 1, onCreate: (db, version) async {
      print('Database created');
      await db
          .execute(
              'Create Table tasks(id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)')
          .then((value) {
        print('CREATE TABLE => success');
      }).catchError((error) {
        print('CREATE TABLE => $error');
      });
    }, onOpen: (db) async {
      database = db;
      print('Database opened');
      getTasks();
    });
  }

  insertInDatabase(String title, String date, String time) async {
    await database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks(title, time, date, status) VALUES("$title","$time","$date","active")')
          .then((value) {
        print('INSERTED');
        print('ROW ID => $value');
        emit(AppInsertTasksState());
        getTasks();
      }).catchError((error) {
        print('INSERT => $error');
      });
    });
  }

  getTasks() async {
    tasks.clear();
    database.rawQuery("SELECT * FROM tasks").then((value) {
      value.forEach((element) {
        if(element['status'] == tasksState) tasks.add(element);
      });
      print(tasks);
      emit(AppGetTasksState());

    });
  }

  updateTask({
    required String status,
    required int id,
  }) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      emit(AppUpdateTasksState());
      getTasks();
    });
  }

  deleteTasks({required int id}){
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
    .then((value){
      emit(AppDeleteTasksState());
      getTasks();
    });
  }


  bool isExpanded = false;

  void changeBottomSheetState(bool isExpanded) {
    this.isExpanded = isExpanded;
    print('SHEET => $isExpanded');
    emit(AppBottomSheetState());
  }

  String tasksState = "active";

  void changeTaskState(String state){
    this.tasksState = state;
    emit(AppChangeTasksState());
    getTasks();
  }

}
