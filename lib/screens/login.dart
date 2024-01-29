import 'package:auto_size_text/auto_size_text.dart';
import 'package:enaam/popups/verifyOtp.dart';
import 'package:enaam/screens/enaam_bottom_nav.dart';
import 'package:enaam/screens/forgotpassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../common/apicalls.dart';
import '../common/enaam_json_parser.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final locator = GetIt.instance<EnaamJsonParser>();
  final locatorAPI = GetIt.instance<ApiCalls>();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final emailValid =
  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  var _isApiCalled = false;
  var errorMessage = "";

  var totalSwitches = 2;
  var _tabIndex = 0;

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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width * 0.55,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              //locator.mJson['login']['header_title'],
                              locator.mLang['login'],
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 32
                              ),
                            ),
                            AutoSizeText(
                              //locator.mJson['login']['header_description'],
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
                          child: Center(
                            child: Image.asset(
                              'assets/images/key.png',
                              width: size.width * 0.2,
                              height: size.width * 0.2,
                            ),
                          ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.008,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ToggleSwitch(
                    minWidth: size.width * 0.4,
                    activeBgColors: [[Color(0xff1B1464)], [Color(0xff1B1464)]],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Color(0xffEEEEEE),
                    inactiveFgColor: Colors.black,
                    initialLabelIndex: _tabIndex,
                    totalSwitches: totalSwitches,
                    customTextStyles: [
                      TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14
                      )
                    ],
                    labels: [
                      //'Winners',
                      locator.mLang['login_with_email'],
                      //'Upcoming Draws'
                      locator.mLang['login_with_phone']
                    ],
                    radiusStyle: false,
                    onToggle: (index) {
                      if(_tabIndex != index){
                        _emailController.clear();
                        setState(() {
                          _tabIndex = index!;
                        });
                        print(index);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
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
                            keyboardType: _tabIndex == 0 ? TextInputType.emailAddress : TextInputType.phone,
                            style: TextStyle(
                                color: Color(0xFF7D7D7D),
                                fontSize: 15
                            ),
                            decoration: InputDecoration(
                              /*suffixIcon: Padding(
                                 padding: EdgeInsets.only(right: 25),
                                 child: Icon(Icons.email_rounded,color: Color(0xFF516365)),
                               ),*/
                              /*suffixIcon: Image.asset(
                                'assets/images/icon_email.png',
                                color: Color(0xFF516365),
                              ),*/
                              contentPadding: EdgeInsets.all(20),
                              //hintText: locator.mJson['login']['textformfield']['email'],
                              hintText: _tabIndex == 0 ? locator.mLang['email'] : locator.mLang['phone_login'],
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
                              if(_tabIndex == 0){
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                else if(!emailValid.hasMatch(value)){
                                  return 'Please enter a valid email i.e. xyz@gmail.com';
                                }
                              }
                              else{
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your mobile number';
                                }
                                else if(value.length < 11){
                                  return 'Please enter 11 digit valid phone number i.e. (03001234567)';
                                }
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.015,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: locator.isObscure,
                            style: TextStyle(
                                color: Color(0xFF7D7D7D),
                                fontSize: 15
                            ),
                            decoration: InputDecoration(
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
                              //hintText: locator.mJson['login']['textformfield']['password'],
                              hintText: locator.mLang['password'],
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
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: AutoSizeText(
                                //locator.mJson['login']['alternate'],
                                locator.mLang['forget_password'],
                                maxLines: 1,
                                style: TextStyle(
                                  color: Color(0xFF1B1464),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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
              _loginUser();
            }

          }
        },
        child: !_isApiCalled ? Text(
          //locator.mJson['login']['submit'],
          locator.mLang['login'],
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
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    setState(() {
      _isApiCalled = true;
      errorMessage = "";
    });

    final email = _tabIndex == 0 ? _emailController.text.trim() : "+92" + _emailController.text.trim().substring(1);
    final password = _passwordController.text.trim();

    final Map<String, String> body = {
      '${_tabIndex == 0 ? 'email' : 'phone'}': email,
      "password": password,
    };

    final response = await locatorAPI.login(body);
    print('_loginUser | ' + response.toString());

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
        final data = response['data'];
        final verStatus = data['status'];
        if(verStatus == 'VER'){
          try{
            locator.showCustomSnackBar('Login Successful',context);
          }
          catch(e){

          }

          await locator.saveUserInfo(data);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              builder: (context) => EnaamBottomNavScreen()), (Route route) => false);
          return;
        }
        await locator.generateOtp(response['data']['userId']);
        _showOtpDialog(data['userId'], data['phone']);
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
          return VerifyOtpPopup(phone: phone,userId: userId, isForgot: false,);
        });
    /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );*/
  }
}
