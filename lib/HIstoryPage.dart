import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import 'HomeScreen.dart';

class HistoryPage extends StatefulWidget {

  //Getting the images uploaded from the cloud firestore
  String? userId;
  HistoryPage({Key? key, this.userId}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List searchResult = [];
  final CollectionReference collectionReference=FirebaseFirestore.instance.collection("users");
  bool _search=false;
  TextEditingController __controller = TextEditingController();
  String tagging = '';//1
  TextEditingController _controller = TextEditingController();
  GlobalKey<FormState> _formKey=GlobalKey<FormState>();

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
              //controller: __controller,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search,color: Colors.red,),
                  prefixText: "#",
                  hintText: "Enter Tag to search"),onChanged: (text){
                print("Hello world THis is the text which is showing when you click somehting $text");
                searchTags(text);
          },),
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
                    Fluttertoast.showToast(msg: "Deleting....");
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => HomeScreen())));

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
      backgroundColor: Colors.amber,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").doc(widget.userId).collection("images").snapshots(),
          builder: (BuildContext context ,  AsyncSnapshot<QuerySnapshot> snapshot)
          {
            if (!snapshot.hasData)
            {
              return (const Center(child: Text("Your History is empty")));
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
                    String Tag = snapshot.data!.docs[index]['Tags'];
                    return Container(
                      child: Card(
                        color: Colors.white70,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
                        //color: Colors.amberAccent, //1
                        child: Column(
                            children: <Widget>[
                              const SizedBox(height: 10,),
                              //BoxDecoration()
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: const Radius.circular(15)),
                                child: Image.network(url,height: 200,),
                              ),
                              //child: Image.network(url,height: 200,)
                              const SizedBox(height: 15),
                              //Text("Email: ${Email}\nPhone Number: ${Phonenumber}\nURL/Website: ${Website}",style: const TextStyle(fontWeight: FontWeight.w500,)),
                              SelectableText("Email: ${Email}\nPhone Number: ${Phonenumber}\nURL/Website: ${Website}",style: const TextStyle(fontWeight: FontWeight.w500,),),
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
                                            Fluttertoast.showToast(msg: "Could not save number / \n Number unavailable",timeInSecForIosWeb: 2);
                                          }
                                        },padding: const EdgeInsets.fromLTRB(25, 10, 20, 15)),
                                        SimpleDialogOption(child: const Text("Add tag",style:const TextStyle(fontWeight: FontWeight.w500)),onPressed: (){
                                          Navigator.of(context).pop();
                                          _justDialog(context).then((value) {
                                            tagging = value!;
                                            print("the value of print is this : ${tagging}");
                                            collectionReference.doc(widget.userId).collection('images').doc(snapshot.data!.docs[index].id).update({
                                              'Tags' : '#$tagging'
                                            });
                                            Fluttertoast.showToast(msg: "Tagged Image,You can search for the Image");
                                          });
                                          // _justDialog(context).then((value) {
                                          //   tagging = value!;
                                          //   print("The value of thing is byebye and something : ${tagging} ${value}");
                                          // });
                                          // showDialog(context: context, builder: (context) {
                                          //   return AlertDialog(
                                          //     title: Text("Add Tag"),
                                          //     content: TextField(
                                          //       decoration: InputDecoration(hintText: "Enter # and tag"),
                                          //       controller: _controller,
                                          //       autofocus: true,
                                          //     ),
                                          //     actions: [
                                          //       TextButton(
                                          //           onPressed: (){},
                                          //           child: Text("SUBMIT"))
                                          //     ],
                                          //   );
                                          // });
                                          //Fluttertoast.showToast(msg: "Rakshith is developing this feature",timeInSecForIosWeb: 3);
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
                                                content: Text("Are you sure you want to delete this data?",style: TextStyle(fontWeight: FontWeight.w500),),
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
                                            },padding: const EdgeInsets.fromLTRB(25, 10, 20, 15)),
                                        // SimpleDialogOption(child: const Text("Copy Email-Id",style: const TextStyle(fontWeight: FontWeight.w500),),onPressed: (){
                                        //   if(Email != ''){
                                        //     Clipboard.setData(ClipboardData(text: Email));
                                        //     Fluttertoast.showToast(msg: "Copied EMail",timeInSecForIosWeb: 3);
                                        //   }
                                        //   else{
                                        //     showSnackbar("Failed to copy Email", Duration(milliseconds: 2000));
                                        //   }
                                        // },padding: const EdgeInsets.fromLTRB(25, 10, 20, 15)),
                                        // SimpleDialogOption(child: const Text("Copy URL",style:const TextStyle(fontWeight: FontWeight.w500)),onPressed: (){
                                        //   if(Website != '' || Website != ' '){
                                        //     Clipboard.setData(ClipboardData(text: Email));
                                        //     Fluttertoast.showToast(msg: "Copied URL",timeInSecForIosWeb: 3);
                                        //   }
                                        //   else {
                                        //     showSnackbar("Failed to copy URL", Duration(milliseconds: 2000));
                                        //   }
                                        //
                                        // },padding: const EdgeInsets.fromLTRB(25, 10, 20, 8))
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
  // void searching_tags(String query) async{
  //   final result = await collectionReference
  //       .doc(widget.userId)
  //       .collection('images')
  //       .where('Tags',isEqualTo: query)
  //       .get();
  //   setState(() {
  //     searchResult = result.docs.map((e) => e.data()).toList();
  //   });
  //
  // }
  // Future<void> Dialog_show(BuildContext context)async{
  //         return await showDialog(context: context, builder: (context){
  //           return AlertDialog(
  //             title: Text("Add Tag"),
  //             content: Form(
  //               key: _formKey,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   TextFormField(
  //                     controller: _controller,
  //                     validator: (value){
  //                       return value!.isNotEmpty ? null : "No Tag Entered";
  //                     },
  //                     decoration: InputDecoration(hintText: "Enter # and Tag"),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                   onPressed: (){
  //                     if(_formKey.currentState!.validate()){
  //                       Navigator.of(context).pop();
  //                     }
  //                   },
  //                   child: Text('SUBMIT'))
  //             ],
  //           );
  //         });
  // }
 Future <String?> _justDialog(BuildContext context) async{
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
       title: Text("Add Tag"),
       content:TextFormField(
         autofocus: true,
         controller: _controller,
         decoration: InputDecoration(prefixText: '#',hintText: "Enter Tag",)),
        actions: [
          TextButton(
              onPressed: (){Navigator.of(context).pop(_controller.text.toString());
              },
              child: Text('SUBMIT'))
        ],
      );
    });
  }

  void submit(){
    _controller.clear();
    print("The values are : ${tagging}");
  }

  void searchTags(String text) {}


}

