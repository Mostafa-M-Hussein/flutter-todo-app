import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_v2/auth/login.dart';
import 'package:todo_app_v2/todo/home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {},
  );

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _confirmPassword = TextEditingController();

  TextEditingController _nameController = TextEditingController(  ) ;


  var _key = GlobalKey<FormState>();

  bool _Autoalidation = false;

  bool isLoading = false;

  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassword.dispose();
    _nameController.dispose() ;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register New Account "),
        centerTitle: true,
      ),
      body: isLoading ?  _form(context) : _form(context),
    );
  }

  void onRegisterClick() async {
    if (!_key.currentState!.validate()) {
      setState(() {
        _Autoalidation = true;

      });
    } else {
      setState(() {
        _Autoalidation = false;
        isLoading = true;
      });
    }


    FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text ).then((value) => 
    {
      FirebaseFirestore.instance.collection('profiles').doc().set({
        'name' : _nameController.text ,
        'user_id' : value.user!.uid ,

      }).then((_) =>
      {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()  )) ,

      }).catchError( (error)
      {
        setState(() {
          _error = error.toString()  ;
          isLoading = false ;

        });
      }) ,

      
    }).catchError( (error)
    {
      setState(() {
        _error = error.toString()  ;
       isLoading = false ;

      });

    }) ; 
    
    
    
    
    
    
    
  }

  Widget _form(BuildContext context) {
    return SingleChildScrollView(
        child: Form(
      autovalidate: _Autoalidation,
      key: _key,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            TextFormField(
              validator: (value) => value!.isEmpty ? "Name is required" : null,
              controller: _nameController ,
              decoration: InputDecoration(hintText: "Name "),
            ),
          SizedBox( height: 16 ) ,


            TextFormField(
              validator: (value) => value!.isEmpty ? "Email is required" : null,
              controller: _emailController,
              decoration: InputDecoration(hintText: "Email"),
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              validator: (value) =>
                  value!.isEmpty ? "Password is required" : null,
              controller: _passwordController,
              decoration: InputDecoration(hintText: "password"),
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              validator: (value) =>
                  value!.isEmpty ? "Confirm is required" : null,
              controller: _confirmPassword,
              decoration: InputDecoration(hintText: "Confirm password"),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                onPressed: onRegisterClick,
                child: Text("Register "),
              ),
            ),
            errorMessage(),
            Row(
              children: [
                Text("Have an Account ?"),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text("login"),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }

  Widget _loading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget errorMessage() {
    FlatButton okButton = FlatButton(
      child: Text("close"),
      onPressed: () {},
    );

    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: Text(_error.toString()),
      actions:
      [
        okButton
      ],
    );
    if (_error == null)
      return Container();
    else
      return alert;



  }
}
