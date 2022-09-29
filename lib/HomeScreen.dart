import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_scanner/Users/users.dart';
import 'package:image_scanner/HomePage.dart';
import 'package:image_scanner/HIstoryPage.dart';
import 'package:image_scanner/ProfilePage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  int currentindex = 0 ; //setting the navigator the first page.

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .get()
        .then((value){
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      First_page(userId: loggedInUser.uid),//userId: ,),
      //CardsShow(),
      HistoryPage(userId: loggedInUser.uid),
      profile_page(),
    ];
    return WillPopScope(
      onWillPop: () async {
        final value=await showDialog<bool>(context: context, builder: (context){
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.exit_to_app_rounded),
                Text("Exit App")
              ],
            ),
            content: Text("Do you want to Exit?"),
            actions: [
              ElevatedButton(onPressed: (){SystemNavigator.pop();}, child: const Text("Exit"),
                style: ElevatedButton.styleFrom(primary: Colors.red),),
              ElevatedButton(onPressed: (){Navigator.of(context).pop(false);}, child: const Text("No")),
            ],
          );
        });
        if (value!=null){
          return Future.value(value);
        }
        else{
          return Future.value(false);
        }
      },
      child: Scaffold(
        //backgroundColor: Color(0xFFadb7d9),
        body: IndexedStack(
          index: currentindex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white60,
          selectedItemColor: Colors.red[800],
          unselectedItemColor: Colors.black,
          currentIndex: currentindex,
          onTap: (index) => setState(() => currentindex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "HOME",
            ),
            /*
            BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_sharp),
            label: "Cards",
            ),
             */
            BottomNavigationBarItem(
              icon: Icon(Icons.history_toggle_off),
              label: "History",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

}
