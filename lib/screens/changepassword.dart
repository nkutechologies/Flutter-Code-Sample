import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';

import '../common/apicalls.dart';
import '../common/enaam_json_parser.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final locator = GetIt.instance<EnaamJsonParser>();
  final locatorAPI = GetIt.instance<ApiCalls>();


  final _formKey = GlobalKey<FormState>();

  TextEditingController _oldpasswordController = TextEditingController();
  TextEditingController _newpasswordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();

  var _isApiCalled = false;
  var errorMessage = "";

  @override
  void initState() {
    //FlutterNativeSplash.remove();
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 30,horizontal: 30),
                      child: Image.asset(
                        'assets/images/back_icon.png',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Center(
                      child: AutoSizeText(
                        //'Change Password',
                        locator.mLang['change_password'],
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            color: Color(0xff272D4E),
                            fontSize: 24),
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox(width: size.width * 0.2,))
                ],
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.025),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _oldpasswordController,
                          obscureText: locator.isObscure,
                          style: TextStyle(
                              color: Color(0xFF7D7D7D),
                              fontSize: 15
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            /*suffixIcon: Padding(
                               padding: EdgeInsets.only(right: 25),
                               child: Icon(Icons.password,color: Color(0xFF516365)),
                             ),*/
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
                            /*suffixIcon: Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Image.asset(
                                'assets/images/icon_lock.png',

                                color: Color(0xFF516365),
                              ),
                            ),*/
                            contentPadding: EdgeInsets.all(20),
                            //hintText: 'Old Password',
                            hintText: locator.mLang['old_password'],
                            hintStyle: TextStyle(
                                color: Color(0xFF7D7D7D),
                                fontSize: 15
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.white,width: 0.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.white,width: 0.5),
                            ),
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your old password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.015,
                        ),
                        TextFormField(
                          controller: _newpasswordController,
                          obscureText: locator.isObscure,
                          style: TextStyle(
                              color: Color(0xFF7D7D7D),
                              fontSize: 15
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            /*suffixIcon: Padding(
                               padding: EdgeInsets.only(right: 25),
                               child: Icon(Icons.password,color: Color(0xFF516365)),
                             ),*/
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
                            /*suffixIcon: Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Image.asset(
                                'assets/images/icon_lock.png',

                                color: Color(0xFF516365),
                              ),
                            ),*/
                            contentPadding: EdgeInsets.all(20),
                            //hintText: locator.mJson['forgotpassword']['textformfield']['newpassword'],
                            hintText: locator.mLang['new_password'],
                            hintStyle: TextStyle(
                                color: Color(0xFF7D7D7D),
                                fontSize: 15
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.white,width: 0.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.white,width: 0.5),
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
                            fillColor: Colors.white,
                            filled: true,
                            /*suffixIcon: Padding(
                               padding: EdgeInsets.only(right: 25),
                               child: Icon(Icons.password,color: Color(0xFF516365)),
                             ),*/
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
                            /*suffixIcon: Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Image.asset(
                                'assets/images/icon_lock.png',

                                color: Color(0xFF516365),
                              ),
                            ),*/
                            contentPadding: EdgeInsets.all(20),
                            //hintText: locator.mJson['forgotpassword']['textformfield']['confirmpassword'],
                            hintText: locator.mLang['confirm_password'],
                            hintStyle: TextStyle(
                                color: Color(0xFF7D7D7D),
                                fontSize: 15
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.white,width: 0.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.white,width: 0.5),
                            ),
                          ),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your confirm password';
                            }
                            else if(_oldpasswordController.text.isNotEmpty && _newpasswordController.text != value){
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
                        /*SizedBox(
                          height: size.height * 0.02,
                        ),
                        Text(
                          locator.mJson['forgotpassword']['alternate'],
                          style: TextStyle(
                            color: Color(0xFF1B1464),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),*/
                        /// Navigate To Login Screen
                        /*GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            emailController.clear();
                            passwordController.clear();
                            _formKey.currentState?.reset();
                            simpleUIController.isObscure.value = true;
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Don\'t have an account?',
                              style: kHaveAnAccountStyle(size),
                              children: [
                                TextSpan(
                                  text: " Sign up",
                                  style: kLoginOrSignUpTextStyle(
                                    size,
                                  ),
                                ),
                              ],
                            ),
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
    );
  }


  Widget loginButton(Size size) {
    return Container(
      width: double.infinity,
      height: size.height * 0.07,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xff0E84C8).withOpacity(1.0),
                Color(0xff26A6DF).withOpacity(1.0)
              ]
          ),
          borderRadius: BorderRadius.circular(8)
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            if(!_isApiCalled){
              _changePass();
            }
          }
        },
        child: !_isApiCalled ? Text(
          //'Update',
          locator.mLang['update'],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400
        ),) : SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        )
      ),
    );
  }

  @override
  void dispose() {
    _oldpasswordController.dispose();
    _newpasswordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePass() async {
    setState(() {
      _isApiCalled = true;
      errorMessage = "";
    });

    final oldPass = _oldpasswordController.text.trim();
    final newPass = _newpasswordController.text.trim();

    final Map<String, dynamic> body = {
      "oldPassword": oldPass,
      "newPassword": newPass,
      "userId": locator.mProfileDetailPage['userId']
    };

    final response = await locatorAPI.changePassord(body);

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
        Navigator.pop(context);
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
