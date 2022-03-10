import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_v2/todo/newtodo.dart';
import 'package:todo_app_v2/todo/home.dart' ;
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _UserId = ' ';

  bool _hasError = false;

  bool _isLoading = false;

  String ?_name  ;

  
  
  
  Future GetUserId() async {
    User? accountUser;
    try {
      User? user = await FirebaseAuth.instance.currentUser;
      accountUser = user;
    } catch (error) {
      setState(() {
        _hasError = (error.toString() != null ? true : true);
      });
    }
    return accountUser;
  }

  @override
  void initState() {



    GetUserId().then((value) => {
          setState(() {

            FirebaseFirestore.instance.collection('profiles').where('user_id' , isEqualTo: value.uid  ).get().then((snapShotQuery) =>
            {

              setState ( ()
              {              _name =  snapShotQuery.docs[0]['name'] ;



              })  ,

            }) ;

            _UserId = value.uid;
            _isLoading = false;


          })
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      drawer: Drawer
        (
        child: ListView(
         children:
         [
           DrawerHeader(child : _isLoading ?  Text('Home') : _hasError ? Text("Error") : Text( _name.toString() ) ) ,
           ListTile(
              title:  Text("Login"),
             trailing:  Icon(Icons.exit_to_app  ),
             onTap:  ()  async
             {
               FirebaseAuth.instance.signOut().then((_) =>  {
                  Navigator.of(context).pop() ,
                 Navigator.of(context).pushReplacement( MaterialPageRoute(builder:  ( context ) => HomeScreen() ))



               } ) ;

             } ,
           )
         ],

        ),
      ) ,
      floatingActionButton: FloatingActionButton(
        onPressed: _newToDo,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(centerTitle: true, title: Text("Home")),
      body: _Content(context),
    );
  }

  _Content(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: _isLoading
          ? loading()
          : (_hasError ? Center(child: Text("")) : _content(context)),
    );
  }

  Widget _content(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('todos')
          .where('user_id', isEqualTo: _UserId.toString())
          .orderBy('done', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: loading());
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError || !snapshot.hasData)
              return Center(child: Text(snapshot.error.toString()));
            return _drawScreen(context, snapshot);
        }
      },
    );
  }

  Widget loading() {
    return CircularProgressIndicator();
  }

  void _newToDo() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NewToDo()),
    );
  }

  _drawScreen(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: ListTile(
                title: Text(
                  data['body'],
                  style: TextStyle(
                      decoration: data['done']
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
                trailing: IconButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('todos')
                        .doc(document.id)
                        .delete();
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                leading: IconButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('todos')
                        .doc(document.id)
                        .update({'done': true});
                  },
                  icon: Icon(
                    Icons.assignment_turned_in,
                    color: data['done'] ? Colors.teal : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
