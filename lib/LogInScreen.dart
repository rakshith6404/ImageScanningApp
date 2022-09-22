import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_scanner/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Signup_Screen.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({Key? key}) : super(key: key);

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {

  @override
  void initState() {
    super.initState();
  }

  //form key used to validate the email and password when the user clicks on login buttonss
  final _formKey = GlobalKey<FormState>();

  //Text editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //FireBase
  final _auth = FirebaseAuth.instance;

  //Setting the show password to true
  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Enter Your Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          )),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText:
      _showPassword, //for hiding the data ie.....star coming after u type the password
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_rounded),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
            icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Enter Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          )),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(40),
      color: Colors.teal,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 15, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          signIn(emailController.text, passwordController.text);
        },
        child: Text(
          "Login",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white38,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 300,
                        child: Image.asset("assets/First_page.png")),
                    emailField,
                    SizedBox(
                      height: 10,
                    ),
                    passwordField,
                    SizedBox(
                      height: 50,
                    ),
                    loginButton,
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Don't have an account?",
                            style: TextStyle(fontSize: 16.8)),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            child: Text(
                              " SignUp",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.blue),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Functioning Login Button

  void signIn(String email, String password) async {
    final prefs  = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn',true);
    prefs.setBool('isIn', true);
    if (_formKey.currentState!.validate()) {
      //A CIRCULAR PROGRESS BAR IS SHOWN
      showDialog(
          context: context,
          builder: (context) {
            return Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                  semanticsLabel: 'Linear progress indicator',
                ));
          });
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
        Fluttertoast.showToast(msg: "Login Successfull"),
        print("LOGIN SUCCESSFUL"),
        /*
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen())),
            
         */
        Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => HomeScreen()))),
        //Navigator.of(context).pop()
      })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}

