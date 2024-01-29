import 'package:auto_size_text/auto_size_text.dart';
import 'package:enaam/popups/verifyOtp.dart';
import 'package:enaam/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';

import '../common/apicalls.dart';
import '../common/enaam_json_parser.dart';

class ForgotPasswordUpdateScreen extends StatefulWidget {
  final int userId;
  ForgotPasswordUpdateScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ForgotPasswordUpdateScreenState createState() => _ForgotPasswordUpdateScreenState();
}

class _ForgotPasswordUpdateScreenState extends State<ForgotPasswordUpdateScreen> {
  final locator = GetIt.instance<EnaamJsonParser>();
  final locatorAPI = GetIt.instance<ApiCalls>();


  final _formKey = GlobalKey<FormState>();

  TextEditingController _newpasswordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();

  var _isApiCalled = false;
  var errorMessage = "";

  @override
  void initState() {
    FlutterNativeSplash.remove();
    locator.isObscure = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Colors.blue,
            resizeToAvoidBottomInset: false,
            body: _buildSmallScreen(size)
        ),
      ),
    );
  }

  Widget _buildSmallScreen(
      Size size,
      ) {
    return Center(
      child: _buildMainBody(
        size,
      ),
    );
  }

  Widget _buildSpinner(Size size){
    return SizedBox(
      width: size.width * 0.1,
      height: size.width * 0.1,
      child: CircularProgressIndicator(
        color: Colors.white,
        backgroundColor: Color(0xFF516365),
        strokeWidth: 5,
      ),
    );
  }

  Widget _buildMainBody(
      Size size,
      ) {
    return SizedBox(
      height: double.infinity,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg_gradient.png"),
              fit: BoxFit.cover),
        ),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.05,vertical: size.height * 0.07),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: size.height * 0.13,
                  width: size.width,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xff26A6DF),
                          Color(0xff0476BF),
                        ],
                      )
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: size.width * 0.55,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              //locator.mJson['forgotpassword']['header_title'],
                              locator.mLang['forgot_password'],
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 24
                              ),
                            ),
                            AutoSizeText(
                              //locator.mJson['forgotpassword']['header_description'],
                              locator.mLang['enter_your_details_below'],
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 15
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Image.asset(
                            'assets/images/key.png',
                            width: size.width * 0.2,
                            height: size.width * 0.2,
                          ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.008,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.025),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _newpasswordController,
                            obscureText: locator.isObscure,
                            style: TextStyle(
                                color: Color(0xFF7D7D7D),
                                fontSize: 15
                            ),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Image.asset(
                                  locator.isObscure
                                      ? 'assets/images/eye.png'
                                      : 'assets/images/eyeclose.png',
                                ),
                                onPressed: () {
                                  setState(() {
                                    locator.isObscureActive();
                                  });
                                },
                              ),
                              contentPadding: EdgeInsets.all(20),
                              //hintText: locator.mJson['forgotpassword']['textformfield']['newpassword'],
                              hintText: locator.mLang['new_password'],
                              hintStyle: TextStyle(
                                  color: Color(0xFF7D7D7D),
                                  fontSize: 15
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Color(0xFFD8D8D8),width: 1),
                              ),
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your new password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.015,
                          ),
                          TextFormField(
                            controller: _confirmpasswordController,
                            obscureText: locator.isObscure,
                            style: TextStyle(
                                color: Color(0xFF7D7D7D),
                                fontSize: 15
                            ),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Image.asset(
                                  locator.isObscure
                                      ? 'assets/images/eye.png'
                                      : 'assets/images/eyeclose.png',
                                ),
                                onPressed: () {
                                  setState(() {
                                    locator.isObscureActive();
                                  });
                                },
                              ),
                              contentPadding: EdgeInsets.all(20),
                              //hintText: locator.mJson['forgotpassword']['textformfield']['confirmpassword'],
                              hintText: locator.mLang['confirm_password'],
                              hintStyle: TextStyle(
                                  color: Color(0xFF7D7D7D),
                                  fontSize: 15
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: Color(0xFFD8D8D8),width: 1),
                              ),
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your confirm password';
                              }
                              else if(_newpasswordController.text != value){
                                return 'Password is not confirmed';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          errorMessage.isNotEmpty ? Text(
                            errorMessage,
                            style: TextStyle(
                                color: const Color(0xFFF82A2A),
                                fontWeight: FontWeight.w400,
                                fontSize: 13
                            ),
                          ) : SizedBox(),
                          /// Login Button
                          loginButton(size),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          /*Text(
                            locator.mJson['forgotpassword']['alternate'],
                            style: TextStyle(
                              color: Color(0xFF1B1464),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton(Size size) {
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.07,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFF3789FF)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        onPressed: () {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            if(!_isApiCalled){
              _forgotPass();
            }
          }
        },
        child: !_isApiCalled ? Text(
          //locator.mJson['forgotpassword']['submit'],
          locator.mLang['submit'],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400
        ),) : SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _newpasswordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  _forgotPass() async {
    setState(() {
      _isApiCalled = true;
      errorMessage = "";
    });

    final password = _newpasswordController.text.trim();

    final Map<String, dynamic> body = {
      "userId": widget.userId,
      "newPassword": password,
    };

    final response = await locator.forgotPassUpdate(body);
    print('_forgotPass | ' + response.toString());

    if(response != null){
      final status = response["status"];
      final message = response["message"];

      //print('_registerUser | ' + status);

      if(status == null || message == null){
        setState(() {
          _isApiCalled = false;
          errorMessage = "Something went wrong. Please try again";
        });
        return;
      }
      if(status == 'Success'){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (context) => LoginScreen()), (Route route) => false);
        return;
      }
      setState(() {
        _isApiCalled = false;
        errorMessage = message;
      });
    }
    else{
      setState(() {
        _isApiCalled = false;
        errorMessage = "Something went wrong. Please try again";
      });
    }
  }
}
