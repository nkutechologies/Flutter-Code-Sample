import 'package:enaam/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../common/apicalls.dart';
import '../common/enaam_json_parser.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({Key? key}) : super(key: key);

  @override
  _PersonalDetailsScreenState createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final locator = GetIt.instance<EnaamJsonParser>();
  final locatorAPI = GetIt.instance<ApiCalls>();


  final _formKey = GlobalKey<FormState>();

   late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;

  final emailValid =
  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  var _isApiCalled = false;
  var errorMessage = "";


  @override
  void initState() {
    //FlutterNativeSplash.remove();
    _firstnameController = TextEditingController(text: locator.mProfileDetailPage['firstName']);
    _lastnameController = TextEditingController(text: locator.mProfileDetailPage['lastName']);
    _mobileController = TextEditingController(text: locator.mProfileDetailPage['phone']);
    _emailController = TextEditingController(text: (locator.mProfileDetailPage['email'] != null && locator.mProfileDetailPage['email'] != "" ? locator.mProfileDetailPage['email'] : ''));
    _dobController = TextEditingController(text: locator.mProfileDetailPage['dob'] != null ? locator.mProfileDetailPage['dob'] : '');

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
                      child: Text(
                        //'Personal Details',
                        locator.mLang['personal_details'],
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: Color(0xff272D4E),
                            fontSize: 24),
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.2,)
                ],
              ),
              SizedBox(
                height: size.height * 0.008,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            //'First Name',
                            locator.mLang['first_name'],
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                color: Color(0xff272D4E),
                                fontSize: 15),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _firstnameController,
                          style: TextStyle(
                              color: Color(0xFF7D7D7D),
                              fontSize: 15
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            /*suffixIcon: Padding(
                               padding: EdgeInsets.only(right: 25),
                               child: Icon(Icons.email_rounded,color: Color(0xFF516365)),
                             ),*/
                            /*suffixIcon: Image.asset(
                              'assets/images/icon_email.png',
                              color: Color(0xFF516365),
                            ),*/
                            contentPadding: EdgeInsets.all(20),
                            hintText: locator.mProfileDetailPage['firstName'],
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
                              return 'Please enter your firstname';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10,),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            //'Last Name',
                            locator.mLang['last_name'],
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                color: Color(0xff272D4E),
                                fontSize: 15),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _lastnameController,
                          style: TextStyle(
                              color: Color(0xFF7D7D7D),
                              fontSize: 15
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            /*suffixIcon: Padding(
                               padding: EdgeInsets.only(right: 25),
                               child: Icon(Icons.email_rounded,color: Color(0xFF516365)),
                             ),*/
                            /*suffixIcon: Image.asset(
                              'assets/images/icon_email.png',
                              color: Color(0xFF516365),
                            ),*/
                            contentPadding: EdgeInsets.all(20),
                            hintText: locator.mProfileDetailPage['lastName'],
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
                              return 'Please enter your lastname';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10,),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            //'Phone',
                            locator.mLang['phone'],
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                color: Color(0xff272D4E),
                                fontSize: 15),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          style: TextStyle(
                              color: Color(0xFF7D7D7D),
                              fontSize: 15
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            /*suffixIcon: Padding(
                               padding: EdgeInsets.only(right: 25),
                               child: Icon(Icons.email_rounded,color: Color(0xFF516365)),
                             ),*/
                            /*suffixIcon: Image.asset(
                              'assets/images/icon_email.png',
                              color: Color(0xFF516365),
                            ),*/
                            contentPadding: EdgeInsets.all(20),
                            hintText: locator.mProfileDetailPage['phone'],
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
                              return 'Please enter your phone number';
                            }
                            else if(value.length < 11){
                              return 'Please enter 11 digit valid phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10,),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            //'Email',
                            locator.mLang['email'],
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                color: Color(0xff272D4E),
                                fontSize: 15),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              color: Color(0xFF7D7D7D),
                              fontSize: 15
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            /*suffixIcon: Padding(
                               padding: EdgeInsets.only(right: 25),
                               child: Icon(Icons.email_rounded,color: Color(0xFF516365)),
                             ),*/
                            /*suffixIcon: Image.asset(
                              'assets/images/icon_email.png',
                              color: Color(0xFF516365),
                            ),*/
                            contentPadding: EdgeInsets.all(20),
                            hintText: locator.mProfileDetailPage['email'] != null && locator.mProfileDetailPage['email'] != "" ? locator.mProfileDetailPage['email'] : locator.mLang['email'],
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
                          readOnly: locator.mProfileDetailPage['email'] != null && locator.mProfileDetailPage['email'] != "" ? true : false,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              if (!emailValid.hasMatch(value)) {
                                return 'Please enter a valid email i.e. xyz@gmail.com';
                              }
                            }
                            return null;
                            /*if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            else if(!emailValid.hasMatch(value)){
                              return 'Please enter a valid email i.e. xyz@gmail.com';
                            }
                            return null;*/
                          },
                        ),
                        SizedBox(height: 10,),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            //'Date of Birth',
                            locator.mLang['date_of_birth'],
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                color: Color(0xff272D4E),
                                fontSize: 15),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _dobController,

                          style: TextStyle(
                              color: Color(0xFF7D7D7D),
                              fontSize: 15
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            /*suffixIcon: Padding(
                               padding: EdgeInsets.only(right: 25),
                               child: Icon(Icons.email_rounded,color: Color(0xFF516365)),
                             ),*/
                            /*suffixIcon: Image.asset(
                              'assets/images/icon_email.png',
                              color: Color(0xFF516365),
                            ),*/
                            contentPadding: EdgeInsets.all(20),
                            hintText: locator.mProfileDetailPage['dob'] ?? locator.mLang['enter_dob'],
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
                          enableInteractiveSelection: true,
                          onTap: () async {
                            DateTime date = DateTime(1900);
                            //FocusScope.of(context).requestFocus(new FocusNode());

                            date = (await showDatePicker(
                                context: context,
                                initialDate:DateTime.now(),
                                firstDate:DateTime(1900),
                                lastDate: DateTime(2100)))!;

                            if(date != null ){
                              String formattedDate = DateFormat('dd-MM-yyyy').format(date);
                              _dobController.text = formattedDate;
                            }else{
                              print("Date is not selected");
                            }
                          },
                          enabled: true,
                          readOnly: true,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your date of birth';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20,),

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
              _updateDetails();
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
    _firstnameController.dispose();
    _lastnameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _updateDetails() async {
    setState(() {
      _isApiCalled = true;
      errorMessage = "";
    });

    final firstname = _firstnameController.text.trim();
    final lasttname = _lastnameController.text.trim();
    final phone = _mobileController.text.trim();
    final dob = _dobController.text.trim();

    final Map<String, dynamic> body = {
      "userId": locator.mProfileDetailPage['userId'],
      "dob": dob,
      "phone": phone,
      "residanceCountry": "Pakistan",
      "lastName": lasttname,
      "firstName": firstname,
      "nationality": "Pakistan",
      "gender": "Male"
    };

    final response = await locatorAPI.updateProfile(body);

    if(response != null){
      final status = response["status"];
      final message = response["message"];

      if(status == null || message == null){
        setState(() {
          _isApiCalled = false;
          errorMessage = "Something went wrong. Please try again";
        });
        return;
      }
      if(status == 'Success'){
        await locator.updateProfileData(response['data']);
        /*locator.mProfileDetailPage = response['data'];
        await locatorAPI.getProfileData(response['data']['userId']);*/
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
