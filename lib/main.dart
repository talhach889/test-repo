import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sayhi/views/credentials/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:sayhi/views/home/home.dart';
import 'package:sayhi/views/state_management/user_provide.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvide(),),
      ],
      child: MaterialApp(
        title: 'Say Hi',
        theme: ThemeData(
            fontFamily: GoogleFonts.varelaRound().fontFamily,
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.deepPurple,
                primaryColorDark: Colors.deepPurple,
                cardColor: Colors.deepPurple[200],
                backgroundColor: Colors.black54,
                errorColor: Colors.red)),
        darkTheme: ThemeData.dark().copyWith(
          focusColor: Colors.purple,
          primaryColorDark: Colors.deepPurple,
          cardColor: Colors.deepPurple[200],
          backgroundColor: Colors.black54,
          errorColor: Colors.red,
          textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: GoogleFonts.varelaRound().fontFamily,
              displayColor: Colors.white),
          primaryTextTheme: ThemeData.dark().textTheme.apply(
                fontFamily: GoogleFonts.varelaRound().fontFamily,
              ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const Home();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.hasError}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.purpleAccent,
                ),
              );
            }
            return const Login();
          },
        ),
      ),
    );
  }
}
