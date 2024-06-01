import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/VerifyEmailPage.dart';
import 'package:users_app/authentication/login_screen.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/splashScreen/splash_screen.dart';
import 'package:users_app/widgets/progress_dialog.dart';


class SignUpScreen extends StatefulWidget
{
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}



class _SignUpScreenState extends State<SignUpScreen>
{
  TextEditingController nametextEditingController = TextEditingController();
  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController phoneextEditingController = TextEditingController();
  TextEditingController passwordtextEditingController = TextEditingController();
  TextEditingController confirmPasswordEditingController = TextEditingController();


  validateForm(){
    if(nametextEditingController.text.length < 4)
      {
        Fluttertoast.showToast(msg: "name must be atleast 4 characters");
      }
    else if(!emailtextEditingController.text.contains("@"))
      {
        Fluttertoast.showToast(msg: "Email is not valid");
      }
    else if(phoneextEditingController.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Phone number is required");
    }
    else if(passwordtextEditingController.text.length < 6)
    {
      Fluttertoast.showToast(msg: "Password must be atleast 6 characters");
    }
    else if(passwordtextEditingController.text != confirmPasswordEditingController.text)
      {
        Fluttertoast.showToast(msg: "Password and Confirm Password do not match.");
      }
    else
    {
      //Navigator.push(context, MaterialPageRoute(builder: (c)=> VerifyEmailPage()));
      saveUserInfoNow();
    }
  }


  saveUserInfoNow() async
  {
    showDialog(
        context: context,
        barrierDismissible: false, //dont want progress dialog disappear when user click outside
        builder: (BuildContext c)
        {
          return ProgressDialog(message: "Processing, Please wait...",); //passing the sign up process
        }
    );

    final User? firebaseUser = (
      await fAuth.createUserWithEmailAndPassword(
        email: emailtextEditingController.text.trim(), //trim for space not counted
        password: passwordtextEditingController.text.trim(), //if executed successfully, pass to firebase
      ).catchError((msg){ //for error chance occur
        Navigator.pop(context);
print(msg);       
 Fluttertoast.showToast(msg: "Error: " + msg.toString());
      })
    ).user;

    if(firebaseUser != null) //if user created successfully
      {
        Map userMap = //create in firebase realtime database
        {
          "id": firebaseUser.uid,
          "name": nametextEditingController.text.trim(),
          "email": emailtextEditingController.text.trim(),
          "phone": phoneextEditingController.text.trim(), //save this info into parent node reference
        };

        DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users"); //panel driver = parent node
        usersRef.child(firebaseUser.uid).set(userMap); //rzzzzzzzzzecognize unique user id

        currentFirebaseUser = firebaseUser;
        Fluttertoast.showToast(msg: "Account has been created.");
        Navigator.push(context, MaterialPageRoute(builder: (c)=> VerifyEmailPage())); //correction splash to verify
    }
    else
      {
        Navigator.pop(context); // if not, display dialog msg
        Fluttertoast.showToast(msg: "Account has not been created.");

      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [

              const SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("images/logo3.png"),
              ),

              const SizedBox(height: 10,),

              const Text(
                "User Registration",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),

              TextField(
                controller: nametextEditingController,
                style: const TextStyle(
                  color: Colors.grey
                ),
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "Name",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                  ),

                ),
              ),

              TextField(
                controller: emailtextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                    color: Colors.grey
                ),
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),

                ),
              ),

              TextField(
                controller: phoneextEditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                    color: Colors.grey
                ),
                decoration: const InputDecoration(
                  labelText: "Phone",
                  hintText: "Phone",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),

                ),
              ),

              TextField(
                controller: passwordtextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true, //password text
                style: const TextStyle(
                    color: Colors.grey
                ),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),

                ),
              ),

              TextField(
                controller: confirmPasswordEditingController,
                keyboardType: TextInputType.text,
                obscureText: true, //password text
                style: const TextStyle(
                    color: Colors.grey
                ),
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  hintText: "Confirm Password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),

                ),
              ),

              const SizedBox(height: 20,),

              ElevatedButton(
                onPressed: ()
                    {
                      validateForm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                      ),
                    ),
              ),

              TextButton(
                child: const Text(
                  "Already have an account? Login Here",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}

