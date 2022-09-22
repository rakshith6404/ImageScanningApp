import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_scanner/HomeScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/services.dart';
class History_page extends StatefulWidget {

  String? userId;
  History_page({Key? key,this.userId}) : super(key: key);

  @override
  State<History_page> createState() => _History_pageState();
}

class _History_pageState extends State<History_page> {
  final CollectionReference collectionReference=FirebaseFirestore.instance.collection("users");

  bool _search=false;

  void tags(){}
  void clearHistory(context){

  }

  @override

  Widget build(BuildContext context) {
    int index;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
          automaticallyImplyLeading: false,
          title: !_search
              ?Text("History")
              :TextField(
              decoration: const InputDecoration(
                  icon: Icon(Icons.search_sharp),
                  hintText: "Search tagged images")),
          actions: <Widget>[
            _search
                ?IconButton(onPressed: (){
              setState(() {
                this._search=!_search;
              });
            }, icon:Icon(Icons.cancel))
                :IconButton(onPressed: (){
              setState(() {
                this._search=!_search;
              });
            }, icon: Icon(Icons.search),tooltip: "Search(tag)",),
            IconButton(onPressed: (){
              var alertDialog=AlertDialog(
                title:Row(
                  children: [
                    Icon(Icons.delete_sharp),
                    Text("Delete"),
                  ],
                ),
                content: const Text("Are you sure you want to clear the history?"),
                actions: [
                  TextButton(child: Text("Cancel"),onPressed: () => Navigator.pop(context)),
                  TextButton(child: Text("Yes"),onPressed: () {
                    delete_History();
                    Fluttertoast.showToast(msg: "Deleted Successfully");
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => HomeScreen())));

                    //Navigator
                  }),
                ],
              );
              showDialog(context: context, builder: (BuildContext context){
                return alertDialog;
              });
            },
              icon: const Icon(Icons.delete_rounded),
              tooltip: "Delete",)
          ]
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").doc(widget.userId).collection("images").snapshots(),
          builder: (BuildContext context ,  AsyncSnapshot<QuerySnapshot> snapshot)
          {
            ///var _isEmpty = snapshot.data!.docs;
            if (!snapshot.hasData)
            {
              return (const Center(child: Text("History is empty",style: TextStyle(fontWeight: FontWeight.w500),)));
            }
            else
            {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (BuildContext context,index)
                  {
                    String url = snapshot.data!.docs[index]['downloadURL'];
                    String Email = snapshot.data!.docs[index]['Email'];
                    String Phonenumber = snapshot.data!.docs[index]['Phone'];
                    String Website = snapshot.data!.docs[index]['Website'];
                    return Container(
                      // height: 300,
                      //clipBehavior: Clip.hardEdge,
                      child: Card(
                        color: Colors.amber[100],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        child: Column(
                            children: <Widget>[
                              const SizedBox(height: 10,),
                              //BoxDecoration()
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: const Radius.circular(5)),
                                child: Image.network(url,height: 200,),
                              ),
                              //child: Image.network(url,height: 200,)
                              const SizedBox(height: 15),
                              Text("Email: ${Email}\nPhone Number: ${Phonenumber}\nURL/Website: ${Website}",style: const TextStyle(fontWeight: FontWeight.w500,)),
                              //SizedBox(height: 5),
                              ButtonBar(
                                alignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextButton(onPressed: (){
                                    var showDialog1=SimpleDialog(
                                      title: const Text("Details",style: const TextStyle(fontWeight: FontWeight.bold),),backgroundColor: Colors.tealAccent,
                                      children: [
                                        SimpleDialogOption(child: const Text("Save Number to contacts",style:const TextStyle(fontWeight: FontWeight.w500)),onPressed: ()async{
                                          if (Phonenumber!=''){
                                            final _url='tel:$Phonenumber';
                                            await canLaunch(_url) ? await launch(_url) : throw "Could not launch $_url";}
                                          else{
                                            Fluttertoast.showToast(msg: "Could not save number or Number unavailable",timeInSecForIosWeb: 2);
                                          }
                                        },padding: const EdgeInsets.fromLTRB(25, 10, 20, 15)),
                                        SimpleDialogOption(child: const Text("Add tag",style:const TextStyle(fontWeight: FontWeight.w500)),onPressed: (){
                                          Fluttertoast.showToast(msg: "Rakshith is developing this feature",timeInSecForIosWeb: 3);
                                        },padding: const EdgeInsets.fromLTRB(25, 10, 20, 15)),
                                        SimpleDialogOption(child: const Text("Delete from history",style:const TextStyle(fontWeight: FontWeight.w500)),
                                            onPressed: (){
                                              var alertDialog=AlertDialog(
                                                title: Row(
                                                  children: const [
                                                    Icon(Icons.delete),
                                                    Text("Delete",style: TextStyle(fontWeight: FontWeight.bold),)
                                                  ],
                                                ),
                                                content: Text("Are you sure you want to delete this data?",style: TextStyle(fontWeight: FontWeight.w400),),
                                                actions: <Widget>[
                                                  SimpleDialogOption(onPressed: (){Navigator.pop(context);},child: Text("Cancel",style: TextStyle(fontWeight: FontWeight.w500))),
                                                  SimpleDialogOption(onPressed: (){
                                                    //deleting that particular data from firebase :smile
                                                    collectionReference.doc(widget.userId).collection("images").doc(snapshot.data!.docs[index].id).delete();
                                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => HomeScreen())));
                                                    Fluttertoast.showToast(msg: "Deleted successfully");
                                                  },
                                                      child: Text("Yes",style: TextStyle(fontWeight: FontWeight.w500))),
                                                ],
                                              );
                                              showDialog(context: context, builder: (BuildContext context) {
                                                return alertDialog;
                                              });
                                            },
                                            padding: const EdgeInsets.fromLTRB(25, 10, 20, 15)),
                                        SimpleDialogOption(child: const Text("Copy Email-Id",style:const TextStyle(fontWeight: FontWeight.w500)),onPressed: (){
                                          if(Email != ''){
                                            Clipboard.setData(ClipboardData(text: Email));
                                            Fluttertoast.showToast(msg: "Copied EMAIL",timeInSecForIosWeb: 3);
                                          }
                                          else {
                                            showSnackbar("Failed to copy Email", Duration(milliseconds: 2000));
                                          }

                                        }, padding: const EdgeInsets.fromLTRB(25, 10, 20, 15)),
                                        SimpleDialogOption(child: const Text("Copy URL",style:const TextStyle(fontWeight: FontWeight.w500)),onPressed: (){
                                          if(Website != '' || Website != ' '){
                                            Clipboard.setData(ClipboardData(text: Email));
                                            Fluttertoast.showToast(msg: "Copied URL",timeInSecForIosWeb: 3);
                                          }
                                          else {
                                            showSnackbar("Failed to copy URL", Duration(milliseconds: 2000));
                                          }

                                        },padding: const EdgeInsets.fromLTRB(25, 10, 20, 8))


                                      ],
                                    );
                                    showDialog(context: context, builder: (BuildContext context){
                                      return showDialog1;
                                    });
                                  },
                                    child: const Text("Details"),
                                  )
                                ],
                              )
                            ]
                        ),
                      ),
                    );
                  });
            }
          }
      ),
    );
  }

  Future delete_History() async{
    var collection = FirebaseFirestore.instance.collection("users").doc(widget.userId).collection("images");
    var snapshots = await collection.get();
    for(var doc in snapshots.docs){
      await doc.reference.delete();
    }

  }
  showSnackbar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

