import 'package:flutter/material.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({Key? key}) : super(key: key);

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.deepPurple[300],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 200.0,
            ),
            child: Card(
              color: Colors.deepPurple.shade50,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Forget Password Text//////////////////////////////////////////////
                       Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 18),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Forget Password',
                            style: TextStyle(
                              fontSize: 36,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      //Email Block ////////////////////////////////////////////
                      Column(
                        children:  [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          //Email text Field///////////////////////////////////////////////////////////////
                          const TextField(
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.deepPurple)),
                                hintText: 'Enter Email',
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 16)),
                          ),
                        ],
                      ),

                      //Submit Button////////////////////////////////////////////
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Text(
                              'Submit Request',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),

                      //Back to login text
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Back to login",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }
}
