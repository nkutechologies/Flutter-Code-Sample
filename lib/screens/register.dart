import 'package:auto_size_text/auto_size_text.dart';
import 'package:enaam/common/apicalls.dart';
import 'package:enaam/popups/enaamLang.dart';
import 'package:enaam/popups/verifyOtp.dart';
import 'package:enaam/screens/enaam_webview.dart';
import 'package:enaam/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';

import '../common/enaam_json_parser.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final locator = GetIt.instance<EnaamJsonParser>();
  final locatorAPI = GetIt.instance<ApiCalls>();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _selectedOperatorController =
      TextEditingController(text: 'Mobile Network');

  var _selectedOperator = 'Mobile Network';
  var _selectedNetworkIndex = -1;
  final _networkList = ['Jazz', 'Telenor', 'Ufone', 'Warid', 'CMPak', 'SCO'];

  final emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  var _isApiCalled = false;
  var errorMessage = "";

  var _isTermAccepted = false;

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
            body: _buildSmallScreen(size)),
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

  Widget _buildSpinner(Size size) {
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
          margin: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, vertical: size.height * 0.07),
          semanticContainer: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
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
                      )),
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
                              //locator.mJson['register']['header_title'],
                              locator.mLang['register_now'],
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 32),
                            ),
                            AutoSizeText(
                              //locator.mJson['register']['header_description'],
                              locator.mLang['enter_your_details_below'],
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 15),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          'assets/images/security_user.png',
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
                            controller: _firstnameController,
                            style: TextStyle(
                                color: Color(0xFF7D7D7D), fontSize: 15),
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
                              //hintText: locator.mJson['register']['textformfield']['firstname'],
                              hintText: locator.mLang['first_name'],
                              hintStyle: TextStyle(
                                  color: Color(0xFF7D7D7D), fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    color: Color(0xFFD8D8D8), width: 1),
                              ),
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your firstname';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.015,
                          ),
                          TextFormField(
                            controller: _lastnameController,
                            style: TextStyle(
                                color: Color(0xFF7D7D7D), fontSize: 15),
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
                              //hintText: locator.mJson['register']['textformfield']['lastname'],
                              hintText: locator.mLang['last_name'],
                              hintStyle: TextStyle(
                                  color: Color(0xFF7D7D7D), fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    color: Color(0xFFD8D8D8), width: 1),
                              ),
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your lastname';
                              }
                              return null;
                            },
                          ),
                          /*SizedBox(
                            height: size.height * 0.015,
                          ),
                          TextFormField(
                            controller: _selectedOperatorController,
                            readOnly: true,
                            style: TextStyle(
                                color: Color(0xFF7D7D7D), fontSize: 15),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              //hintText: locator.mJson['register']['textformfield']['lastname'],
                              hintText: _selectedOperator,
                              hintStyle: TextStyle(
                                  color: Color(0xFF7D7D7D), fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    color: Color(0xFFD8D8D8), width: 1),
                              ),
                            ),
                            onTap: () {
                              _showNetworkList(size);
                            },
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  _selectedOperator == 'Mobile Network') {
                                return 'Please select mobile network';
                              }
                              return null;
                            },
                          ),*/
                          SizedBox(
                            height: size.height * 0.015,
                          ),
                          TextFormField(
                            controller: _mobileController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            style: TextStyle(
                                color: Color(0xFF7D7D7D), fontSize: 15),
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
                              //hintText: locator.mJson['register']['textformfield']['mobile'],
                              hintText: locator.mLang['phone'],
                              hintStyle: TextStyle(
                                  color: Color(0xFF7D7D7D), fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    color: Color(0xFFD8D8D8), width: 1),
                              ),
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your mobile number';
                              } else if (value.length < 11) {
                                return 'Please enter 11 digit valid phone number i.e. (03001234567)';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.015,
                          ),
                          Container(
                            width: size.width,
                            child: Center(
                              child: AutoSizeText(
                                locator.mLang['or'],
                                maxLines: 1,
                                style: TextStyle(
                                  color: Color(0xFF7D7D7D),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.015,
                          ),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                color: Color(0xFF7D7D7D), fontSize: 15),
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
                              //hintText: locator.mJson['register']['textformfield']['email'],
                              hintText: locator.mLang['email'],
                              hintStyle: TextStyle(
                                  color: Color(0xFF7D7D7D), fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    color: Color(0xFFD8D8D8), width: 1),
                              ),
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (!emailValid.hasMatch(value)) {
                                  return 'Please enter a valid email i.e. xyz@gmail.com';
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
                                color: Color(0xFF7D7D7D), fontSize: 15),
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
                              //hintText: locator.mJson['register']['textformfield']['password'],
                              hintText: locator.mLang['password'],
                              hintStyle: TextStyle(
                                  color: Color(0xFF7D7D7D), fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    color: Color(0xFFD8D8D8), width: 1),
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
                            height: size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 23,
                                height: 25,
                                child: Checkbox(
                                    value: _isTermAccepted,
                                    side: BorderSide(
                                        width: 1, color: Color(0xffD8D8D8)),
                                    onChanged: (value) {
                                      setState(() {
                                        _isTermAccepted = value!;
                                      });
                                    }),
                              ),
                              Container(
                                margin: EdgeInsetsDirectional.only(start: 5),
                                child: AutoSizeText(
                                  //'I agree to ',
                                  locator.mLang['i_agree_to'],
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Color(0xFF7D7D7D),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const EnaamWebview(url: 'https://enaam.pk/terms.php')),
                                  );
                                },
                                child: AutoSizeText(
                                  //'Usage and Terms',
                                  locator.mLang['usage_terms'],
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Color(0xFF7D7D7D),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              AutoSizeText(
                                //' and ',
                                locator.mLang['and'],
                                maxLines: 1,
                                style: TextStyle(
                                  color: Color(0xFF7D7D7D),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const EnaamWebview(url: 'https://enaam.pk/privacy.php')),
                                    );
                                  },
                                  child: AutoSizeText(
                                    //'Privacy Policy',
                                    locator.mLang['privacy_policy'],
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Color(0xFF7D7D7D),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          errorMessage.isNotEmpty
                              ? Text(
                                  errorMessage,
                                  style: TextStyle(
                                      color: const Color(0xFFF82A2A),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13),
                                )
                              : SizedBox(),

                          /// Login Button
                          loginButton(size),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: AutoSizeText(
                                //locator.mJson['register']['alternate'],
                                locator.mLang['existing_user_login'],
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
            if (!_isTermAccepted) {
              setState(() {
                errorMessage = 'Please accept terms and usages/privacy';
              });
              return;
            }
            if (!_isApiCalled) {
              _registerUser();
            }
          }
        },
        child: !_isApiCalled
            ? Text(
                //locator.mJson['register']['submit'],
                locator.mLang['continue'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              )
            : SizedBox(
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
    _firstnameController.dispose();
    _lastnameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _selectedOperatorController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    setState(() {
      _isApiCalled = true;
      errorMessage = "";
    });

    final firstname = _firstnameController.text.trim();
    final lasttname = _lastnameController.text.trim();
    final phone = _mobileController.text.trim().isNotEmpty
        ? '+92' + _mobileController.text.trim().substring(1)
        : '';
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final Map<String, String> body = {
      "phone": phone,
      "residanceCountry": "Pakistan",
      "lastName": lasttname,
      "firstName": firstname,
      "email": email,
      "password": password,
      "nationality": "Pakistan",
      "gender": "Male",
      //"mobileNetwork": _selectedNetworkIndex.toString(),
    };

    final response = await locatorAPI.register(body);
    //print('_registerUser | ' + response.toString());

    if (response != null) {
      final status = response["status"];
      final message = response["message"];

      //print('_registerUser | ' + status);

      if (status == null || message == null) {
        setState(() {
          _isApiCalled = false;
          errorMessage = "Something went wrong. Please try again";
        });
        return;
      }
      if (status == 'Success') {
        final userId = response['data']['userId'];
        _showOtpDialog(userId, phone);
        return;
      }
      setState(() {
        _isApiCalled = false;
        errorMessage = message;
      });
    } else {
      setState(() {
        _isApiCalled = false;
        errorMessage = "Something went wrong. Please try again";
      });
    }
  }

  _showOtpDialog(userId, String phone) async {
    showDialog(
        context: context,
        builder: (builder) {
          return VerifyOtpPopup(
            phone: phone,
            userId: userId,
            isForgot: false,
          );
        });
    /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );*/
  }

  void _showNetworkList(Size size) {
    showModalBottomSheet(
      context: context,

      // backgroundColor: Colors.transparent,
      builder: (context) => Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                setState(() {
                  _selectedOperator = _networkList[0];
                  _selectedNetworkIndex = 1;
                  _selectedOperatorController.text = _networkList[0];
                });
              },
              child: Container(
                height: size.height * 0.06,
                child: Center(
                  child: Text(
                    _networkList[0],
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
            ),
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                setState(() {
                  _selectedOperator = _networkList[1];
                  _selectedNetworkIndex = 2;
                  _selectedOperatorController.text = _networkList[1];
                });
              },
              child: Container(
                height: size.height * 0.06,
                child: Center(
                  child: Text(
                    _networkList[1],
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
            ),
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                setState(() {
                  _selectedOperator = _networkList[2];
                  _selectedNetworkIndex = 3;
                  _selectedOperatorController.text = _networkList[2];
                });
              },
              child: Container(
                height: size.height * 0.06,
                child: Center(
                  child: Text(
                    _networkList[2],
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
            ),
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                setState(() {
                  _selectedOperator = _networkList[3];
                  _selectedNetworkIndex = 4;
                  _selectedOperatorController.text = _networkList[3];
                });
              },
              child: Container(
                height: size.height * 0.06,
                child: Center(
                  child: Text(
                    _networkList[3],
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
            ),
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                setState(() {
                  _selectedOperator = _networkList[4];
                  _selectedNetworkIndex = 5;
                  _selectedOperatorController.text = _networkList[4];
                });
              },
              child: Container(
                height: size.height * 0.06,
                child: Center(
                  child: Text(
                    _networkList[4],
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
            ),
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                setState(() {
                  _selectedOperator = _networkList[5];
                  _selectedNetworkIndex = 6;
                  _selectedOperatorController.text = _networkList[5];
                });
              },
              child: Container(
                height: size.height * 0.06,
                child: Center(
                  child: Text(
                    _networkList[5],
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
