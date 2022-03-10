import 'package:flutter/material.dart';
import 'package:todo_app_v2/auth/register.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold

      (
      appBar: AppBar(
        title: Text("Login Screen "),
        centerTitle: true ,
      ) ,

    body: SingleChildScrollView(
      child: Padding
        (
        padding: EdgeInsets.all(36 ),
        child : Column
          (
          children:
          <Widget> [

            TextFormField(
              decoration: InputDecoration
                (
                hintText: "Your Email" ,

              ) ,
            ) ,
            SizedBox(height: 16,) ,

            TextFormField(
              obscureText: true ,
              decoration: InputDecoration
                (
                hintText: "Your Password" ,

              ) ,
            ),


          Container
              (
              width: double.infinity ,
            child: RaisedButton
              (
              onPressed:  () {} ,
              child: Text("Login"),
            ) ,
          ),




            Row(
              children:
              [
                Text("Dont have account ") ,
                FlatButton(onPressed: () 
                {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute( builder: (context) => RegisterScreen() )
                  );


                } , child: Text("register ")) ,
              ],
            )



          ],
        )
      ),
    ),
    );
  }
}
