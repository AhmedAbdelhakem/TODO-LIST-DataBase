import 'package:database/database/app_cubit.dart';
import 'package:database/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_state.dart';

class HomeScreen extends StatelessWidget {
  var context;
  late AppCubit cubit;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return BlocProvider(
      create: (context) =>
      AppCubit(AppInitState())
        ..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          cubit = AppCubit.get(context);
          return Scaffold(
            key: _scaffoldKey,
            appBar: (AppBar(
              title: Text(cubit.title[cubit.position]),
            )),
            floatingActionButton: cubit.tasksState == "active"
                ? buildFloatingButton()
                : null,
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.task), label: cubit.title[0]),
                BottomNavigationBarItem(
                    icon: Icon(Icons.done), label: cubit.title[1]),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: cubit.title[2]),
              ],
              currentIndex: cubit.position,
              onTap: (value) {
                // setState(() {
                //   _position = value;
                // });
                switch (value) {
                  case 0:
                    {
                      cubit.changeTaskState("active");
                    }
                    break;
                  case 1:
                    {
                      cubit.changeTaskState("done");
                    }
                    break;
                  case 2:
                    {
                      cubit.changeTaskState("archive");
                    }
                    break;
                }
                cubit.onBottomNavigationChange(value);
              },
            ),
            body: cubit.screens[cubit.position],
          );
        },
      ),
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   createDatabase();
  // }

  Widget buildInsertSheet() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            myTextField(
              controller: titleController,
              iconData: Icons.task_alt_outlined,
              label: "Title",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Tile required";
                }
                return null;
              },
            ),
            myTextField(
              controller: dateController,
              iconData: Icons.date_range_rounded,
              label: "Date",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Date required";
                }
                return null;
              },
              onTap: () => _selectDate(context),
            ),
            myTextField(
              controller: timeController,
              iconData: Icons.access_time_rounded,
              label: "Time",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Time required";
                }
                return null;
              },
              onTap: () => _selectTime(context),
            )
          ],
        ),
      ),
    );
  }

  Widget buildFloatingButton() {
    return FloatingActionButton(
      onPressed: () {
        if (cubit.isExpanded) {
          if (formKey.currentState!.validate()) {
            String title = titleController.text;
            String date = dateController.text;
            String time = timeController.text;

            print('$title, $date, $time');

            cubit.insertInDatabase(title, date, time);

            Navigator.pop(context);
          }
        } else {
          _scaffoldKey.currentState!
              .showBottomSheet((context) => buildInsertSheet(),
              elevation: 100, backgroundColor: Colors.white)
              .closed
              .then((value) {
            cubit.changeBottomSheetState(false);
            titleController.text = "";
            dateController.text = "";
            timeController.text = "";
          });
        }

        cubit.changeBottomSheetState(true);
        // setState(() {
        //   _isExpanded = true;
        // });

        // showCupertinoModalPopup(
        //   context: context,
        //   builder: (context) => Container(
        //     height: 400,
        //     color: Colors.blue,
        //   ),
        // );
      },
      child: Icon(
        cubit.isExpanded ? Icons.add : Icons.edit,
        color: Colors.white,
      ),
    );
  }

  _selectDate(context) {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2001, 10, 1),
        lastDate: DateTime(2121, 10, 1))
        .then((value) {
      if (value != null) {
        String date = "${value.year}/${value.month}/${value.day}";
        dateController.text = date;
      }
    });
  }

  _selectTime(context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 7, minute: 15),
    ).then((value){
      if (value != null){
        String time = "${value.hour}:${value.minute} ${value.period}";
        timeController.text = time;
      }
    });
    // if (newTime != null) {
    //   setState(() {
    //     _time = newTime;
    //   });
    }
  }
