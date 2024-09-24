import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:notes_app/notes_model.dart';
import 'package:notes_app/notes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Notes> list = [];
  late SharedPreferences sharedPreferences;
  getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    List<String>? stringList = sharedPreferences.getStringList("list");
    if (stringList != null) {
      list =
          stringList.map((items) => Notes.fromMap(jsonDecode(items))).toList();
    }
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddNotes'),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                20,
              ),
              border: Border.all(
                color: Colors.blue,
              ),
            ),
            width: double.infinity,
            height: 400,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(
                      fontSize: 30,
                      color: Colors.grey,
                    ),
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: BeveledRectangleBorder(),
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              list.insert(
                  0,
                  Notes(
                      title: titleController.text,
                      description: descriptionController.text));
              List<String> stringList =
                  list.map((items) => jsonEncode(items.toMap())).toList();
              sharedPreferences.setStringList("list", stringList);
              Navigator.pop(context, "Load data");
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
