import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayhi/views/credentials/login.dart';
import 'package:sayhi/views/state_management/user_provide.dart';
import 'package:sayhi/model/user.dart' as model;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  bool _isLoading = false;

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
      Future.delayed(const Duration(seconds: 2), _delay);
    });
    await FirebaseAuth.instance.signOut();
    setState(() {
      _isLoading = false;
      Future.delayed(const Duration(seconds: 1), _delay);
    });
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => const Login()),
            (route) => false);
  }

  Future _delay() async{
    setState((){
      _isLoading = false;
    });
  }


  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel",style: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.bold)),
      onPressed:  () {
        Navigator.of(context).pop();
        },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue",style: TextStyle(fontWeight: FontWeight.bold)),
      onPressed:  () {
        _signOut();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Sign out",style: TextStyle(fontWeight: FontWeight.bold)),
      content: const Text("Would you like to Sign out to SayHi"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    model.User user = Provider.of<UserProvide>(context).getUser;

    return Scaffold(
      appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  showAlertDialog(context);
                },
              );
            },
          ),
          centerTitle: true,
          title: const Text('Say Hi'),
          backgroundColor: Colors.deepPurple
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'logged in as ${user.username}',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: (){
                showAlertDialog(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20,bottom: 20,left: 80,right: 80),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(15),
                  ),child: _isLoading? const Center(child: CircularProgressIndicator(
                  color: Colors.white,
                )): const Center(
                  child: Text(
                    'Log out',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
