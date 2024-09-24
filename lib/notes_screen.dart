import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/add_notes.dart';
import 'package:notes_app/notes_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late SharedPreferences sharedPreferences;
  List<Notes> list = [];
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
        title: Text('Notes'),
        centerTitle: true,
      ),
      body: list.isEmpty
          ? Center(
              child: Text('No Notes'),
            )
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(list[index].title),
                  subtitle: Text(list[index].description),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        list.removeAt(index);
                        List<String> stringList = list
                            .map((items) => jsonEncode(items.toMap()))
                            .toList();
                        sharedPreferences.setStringList("list", stringList);
                      });
                    },
                    icon: Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String refresh = await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => AddNotes(),
            ),
          );

          if (refresh == "Load data") {
            setState(() {
              getData();
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
