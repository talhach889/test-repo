import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayhi/views/home/navigation_pages/add_post.dart';
import 'package:sayhi/views/home/navigation_pages/moments_page.dart';
import 'package:sayhi/views/home/navigation_pages/post_page.dart';
import 'package:sayhi/views/home/navigation_pages/profile_page.dart';
import 'package:sayhi/views/home/navigation_pages/search_user_page.dart';
import 'package:sayhi/views/state_management/user_provide.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    PostPage(),
    MomentsPage(),
    AddPost(),
    SearchUser(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  String username = "";

  @override
  void initState(){
    super.initState();
    addData();
  }

  addData()async{
    UserProvide _userProvide = Provider.of(context,listen: false);
    await _userProvide.refreshUser();
  }
  // void getUsername() async {
  //   DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //
  //   setState(() {
  //     username = (snapshot.data() as Map<String, dynamic>)['username'];
  //   });
  //   print(username);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                //active icon
                label: 'Home',
                backgroundColor: Colors.deepPurple
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_library),
                label: 'Moments',
                backgroundColor: Colors.deepPurple
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined),
                label: 'Share Something',
                backgroundColor: Colors.deepPurple
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
                backgroundColor: Colors.deepPurple
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.deepPurple,
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          iconSize: 30,
          onTap: _onItemTapped,
          elevation: 5
      ),
    );
  }
}