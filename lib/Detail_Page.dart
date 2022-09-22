import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:flutter/material.dart';
class Details extends StatefulWidget {
  //String? text;
  String? email;
  String? phone;
  String? website;
  XFile? images;
  Details({this.images, this.email, this.phone, this.website});
  @override
  _DetailsState createState() => _DetailsState(images, email, phone, website);
}

class _DetailsState extends State<Details> {
  void showSimpleDialog(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            "Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: [
            SimpleDialogOption(
                child: Text("Save Number to contacts",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                onPressed: () async {
                  if (phone != '') {
                    final _url = 'tel:$phone';
                    await canLaunch(_url)
                        ? await launch(_url)
                        : throw "Could not launch $_url";
                  } else {
                    Fluttertoast.showToast(
                        msg: "No number Available", timeInSecForIosWeb: 1);
                  }
                },
                padding: EdgeInsets.fromLTRB(25, 15, 20, 25)),
            //SimpleDialogOption(child: Text("Add tag",style:TextStyle(fontWeight: FontWeight.w500)),onPressed: (){},)
          ],
        );
      });

  XFile? images;
  //String? text;
  String? email;
  String? phone;
  String? website;

  _DetailsState(this.images, this.email, this.phone, this.website);
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  @override

  Widget build(BuildContext context) {
    return Scaffold(

        key: _key,
        backgroundColor: Colors.grey[400],
        appBar: AppBar(
          title: Text('Details'),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(5, 40, 5, 45),
          child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(30),
                child: Card(
                  //clipBehavior: Clip.antiAlias,
                    color: Colors.blueGrey[50],
                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 5),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 15, 15, 15),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.file(File(images!.path),
                                      height: 250, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(1, 10, 10, 1),
                          child: Text(
                            "Email: ${email}\n"
                                "Phone: ${phone}\n\n"
                                "Website: ${website}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                showSimpleDialog(context);
                              },
                              child: Text("Details"),
                            )
                          ],
                        )
                      ],
                    )
                  //child: Image.file(File(images!.path)),
                )),
          ),
        ));
    printing_values();

  }

  Future printing_values() async {
    print("The email is ${email}");
    print("The email is ${phone}");
    print("The email is ${website}");
    //print("The email is ${email}");
  }
}