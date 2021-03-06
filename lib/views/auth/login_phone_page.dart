import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ib/Utils/constants.dart';
import 'package:ib/Utils/responsive.dart';
import 'package:ib/Utils/firebaseConstants.dart';
import 'package:ib/views/auth/otp_page.dart';

class LoginPhonePage extends StatefulWidget {
  @override
  _LoginPhonePageState createState() => _LoginPhonePageState();
}

class _LoginPhonePageState extends State<LoginPhonePage> {
  String verificationId;

  final _formKey = GlobalKey<FormState>();
  final requiredValidator =
      RequiredValidator(errorText: 'This field is required');
  final userNameValidator =
      EmailValidator(errorText: 'Enter a valid email address');
  final phoneNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
        bottom: false,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        icon: Icon(Icons.arrow_back_sharp),
                        iconSize: 32,
                        color: kTitleColor,
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    padding:
                        const EdgeInsets.only(left: 30, right: 20, bottom: 0),
                    child: Text(
                      'Welcome!',
                      style: TextStyle(
                          color: kTitleColor,
                          fontSize: 38,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding:
                        const EdgeInsets.only(left: 30, right: 20, bottom: 10),
                    child: Text(
                      'Sign in with your Phone No.',
                      style: TextStyle(
                          color: kTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  _loginForm(),
                  Container(
                    margin: EdgeInsets.only(top: 80),
                    child: FlatButton(
                        height: 40,
                        minWidth: SizeConfig.screenWidth * 0.6,
                        clipBehavior: Clip.antiAlias,
                        color: kBlueColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadiusDirectional.circular(8.0)),
                        onPressed: () async {
//firebase code start
                          if (_formKey.currentState.validate()) {
                            Loader.show(context,
                                progressIndicator: CircularProgressIndicator());
                            var phoneNo = phoneNoController.text;
                            print(' phoneNo : $phoneNo');
                            try {
                              await auth.verifyPhoneNumber(
                                  phoneNumber: '+91$phoneNo',
                                  codeAutoRetrievalTimeout: (String verId) {
                                    this.verificationId = verId;
                                  },
                                  codeSent: (String verificationId,
                                      [int forceResendingToken]) {
                                    Loader.hide();

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                OTPPage(
                                                    verificationId:
                                                        verificationId)));
                                  },
                                  timeout: const Duration(seconds: 20),
                                  verificationCompleted:
                                      (AuthCredential phoneAuthCredential) {
                                    Loader.hide();
                                    print(phoneAuthCredential);
                                  },
                                  verificationFailed: (exceptio) {
                                    Loader.hide();
                                    Fluttertoast.showToast(
                                        msg: "${exceptio.message}");
                                    print('${exceptio.message}');
                                  });
                            } catch (err) {
                              if (err.code ==
                                  'ERROR_INVALID_VERIFICATION_CODE') {
                                Loader.hide();
                                Fluttertoast.showToast(msg: "${err.message}");
                              } else {
                                Loader.hide();
                                Fluttertoast.showToast(msg: "${err.message}");
                              }
                            }
                          }
                        },
                        child: Text('login'.toUpperCase(),
                            style: TextStyle(
                                letterSpacing: 2,
                                color: kWhiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold))),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  /*   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?',
                          style: TextStyle(
                            color: kTextColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          )),
                      InkWell(
                        child: Text(' Sing Up',
                            style: TextStyle(
                              color: kBlueColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SignUpPage()));
                        },
                      )
                    ],
                  ), */
                ],
              ),
            ),
          ),
        ));
  }

  _loginForm() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                style: TextStyle(
                    color: kBlueColor,
                    fontSize: 18,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 50, left: 4, right: 5, bottom: 5),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kTextColor, width: 1),
                    ),
                    hintText: 'phone number',
                    hintStyle: TextStyle(
                        color: kTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kBlueColor, width: 1))),
                autofocus: false,
                validator: validateMobile,
                controller: phoneNoController,
              ),
            ],
          )),
    );
  }

  String validateMobile(String value) {
    if (value.isEmpty)
      return 'This field is required';
    else if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }
}
