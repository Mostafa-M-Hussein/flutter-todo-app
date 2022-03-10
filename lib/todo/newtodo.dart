import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_v2/models/todo.dart';

class NewToDo extends StatefulWidget {
  const NewToDo({Key? key}) : super(key: key);

  @override
  _NewToDoState createState() => _NewToDoState();
}

class _NewToDoState extends State<NewToDo> {
  var _key = GlobalKey<FormState>();
  TextEditingController _todoController = TextEditingController();
  bool _autoValidate = false;

  bool isLoading = false;

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: _saveToDo,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("New todo"),
      ),
      body: isLoading ? _loading(context) : _form(context),
    );
  }

  Widget _form(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Form(
            autovalidate: _autoValidate,
            key: _key,
            child: Column(
              children: [
                TextFormField(
                  controller: _todoController,
                  validator: (value) =>
                      value!.isEmpty ? "required todo " : null,
                  decoration: InputDecoration(hintText: "Enter to Do "),
                )
              ],
            )),
      ),
    );
  }

  Widget _loading(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }

  void _saveToDo() async {
    if (!_key.currentState!.validate()) {
      _autoValidate = true;
    } else {
      setState(() {
        isLoading = true;
      });

      FirebaseFirestore.instance.collection('todos').doc().set({
        'body': _todoController.text,
        'done' : false ,
        'user_id': FirebaseAuth.instance.currentUser!.uid,
      }).then((value) => {Navigator.of(context).pop()});
    }
  }
}
