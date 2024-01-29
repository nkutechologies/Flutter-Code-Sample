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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final locator = GetIt.instance<EnaamJsonParser>();
  final locatorAPI = GetIt.instance<ApiCalls>();


  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();

  /*TextEditingController _oldpasswordController = TextEditingController();
  TextEditingController _newpasswordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();*/

  final emailValid =
  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  var _isApiCalled = false;
  var errorMessage = "";

  @override
  void initState() {
    FlutterNativeSplash.remove();
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
                            controller: _emailController,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                                color: Color(0xFF7D7D7D),
                                fontSize: 15
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              //hintText: locator.mJson['forgotpassword']['textformfield']['email'],
                              hintText: locator.mLang['phone_login'],
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
                              /*if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              else if(!emailValid.hasMatch(value)){
                                return 'Please enter a valid email i.e. xyz@gmail.com';
                              }*/
                              if (value == null || value.isEmpty) {
                                return 'Please enter your mobile number';
                              }
                              else if(value.length < 11){
                                return 'Please enter 11 digit valid phone number i.e. (03001234567)';
                              }
                              return null;
                            },
                          ),
                          /*TextFormField(
                            controller: _oldpasswordController,
                            obscureText: true,
                            style: TextStyle(
                                color: Color(0xFF7D7D7D),
                                fontSize: 15
                            ),
                            decoration: InputDecoration(

                              suffixIcon: Image.asset(
                                'assets/images/eye.png',
                              ),
                              contentPadding: EdgeInsets.all(20),
                              hintText: locator.mJson['forgotpassword']['textformfield']['email'],
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
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.015,
                          ),
                          TextFormField(
                            controller: _newpasswordController,
                            obscureText: true,
                            style: TextStyle(
                                color: Color(0xFF7D7D7D),
                                fontSize: 15
                            ),
                            decoration: InputDecoration(
                              suffixIcon: Image.asset(
                                'assets/images/eye.png',
                              ),
                              contentPadding: EdgeInsets.all(20),
                              hintText: locator.mJson['forgotpassword']['textformfield']['newpassword'],
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
                            obscureText: true,
                            style: TextStyle(
                                color: Color(0xFF7D7D7D),
                                fontSize: 15
                            ),
                            decoration: InputDecoration(
                              *//*suffixIcon: Padding(
                                 padding: EdgeInsets.only(right: 25),
                                 child: Icon(Icons.password,color: Color(0xFF516365)),
                               ),*//*
                              suffixIcon: Image.asset(
                                'assets/images/eye.png',
                              ),
                              *//*suffixIcon: Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: Image.asset(
                                  'assets/images/icon_lock.png',

                                  color: Color(0xFF516365),
                                ),
                              ),*//*
                              contentPadding: EdgeInsets.all(20),
                              hintText: locator.mJson['forgotpassword']['textformfield']['confirmpassword'],
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
                              else if(_oldpasswordController.text.isNotEmpty && _newpasswordController.text != value){
                                return 'Password is not confirmed';
                              }
                              return null;
                            },
                          ),*/
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
                          AutoSizeText(
                            //locator.mJson['forgotpassword']['alternate'],
                            "",
                            style: TextStyle(
                              color: Color(0xFF1B1464),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
        child: !_isApiCalled ? AutoSizeText(
          //locator.mJson['forgotpassword']['submit'],
          locator.mLang['submit'],
          maxLines: 1,
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
    _emailController.dispose();
    /*_oldpasswordController.dispose();
    _newpasswordController.dispose();
    _confirmpasswordController.dispose();*/
    super.dispose();
  }

  Future<void> _forgotPass() async {
    setState(() {
      _isApiCalled = true;
      errorMessage = "";
    });

    //final email = _emailController.text.trim();
    final phone = "+92" + _emailController.text.trim().substring(1);

    final Map<String, String> body = {
      "email": phone,
    };

    final response = await locatorAPI.forgotPass(body);
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
        _showOtpDialog(response['userId'], phone);
        return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
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

  _showOtpDialog(userId, String phone) async {
    showDialog(
        context: context,
        builder: (builder){
          return VerifyOtpPopup(phone: phone,userId: userId, isForgot: true,);
        });
  }
}
