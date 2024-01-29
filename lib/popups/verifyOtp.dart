import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:enaam/screens/enaam_bottom_nav.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get_it/get_it.dart';

import '../common/enaam_json_parser.dart';
import '../screens/forgotpasswordupdate.dart';

class VerifyOtpPopup extends StatefulWidget {
  final String phone;
  final int userId;
  final bool isForgot;
  const VerifyOtpPopup({Key? key, required this.phone, required this.userId, required this.isForgot}) : super(key: key);

  @override
  _VerifyOtpPopupState createState() => _VerifyOtpPopupState();
}

class _VerifyOtpPopupState extends State<VerifyOtpPopup> {
  final locator = GetIt.instance<EnaamJsonParser>();
  Timer? _timer = null;
  int _start = 60;

  var _isApiCalled = false;
  var errorMessage = "";
  var _otp = '';

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
              /*boxShadow: [
                BoxShadow(
                  color: Color(0xffD7E4F980).withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 52.85,
                  offset: Offset(
                      0, 18), // changes position of shadow
                ),
              ],*/
              borderRadius:
              BorderRadius.all(Radius.circular(10))),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              AutoSizeText(
                //'Verification',
                locator.mLang['verification'],
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 27
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              AutoSizeText(
                //'Code sent to your number',
                locator.mLang['code_sent_to_your_number'],
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16
                ),
              ),
              AutoSizeText(
                widget.phone,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              OtpTextField(
                numberOfFields: 4,
                borderWidth: 1,
                borderColor: Color(0xFFD3D3D3),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                fillColor: Color(0xffF2F2F2),filled: true,
                keyboardType: TextInputType.number,
                fieldWidth: 50,
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  //handle validation or checks here
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode){
                  _otp = verificationCode;
                  print(verificationCode);
                }, // end onSubmit
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
              SizedBox(
                height: size.height * 0.03,
              ),
              AutoSizeText(
                '00:' + _start.toString(),
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    //text: 'Didn’t recieve code?',
                    text: locator.mLang['didnt_receive_code'],
                    style: TextStyle(
                        color: Color(0xff000000),
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          //text: 'Resend',
                          text: locator.mLang['resend'],
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                            if(_start == 0){
                              await locator.generateOtp(widget.userId);
                              startTimer();
                            }

                            }),
                    ]),
              ),
              Container(
                width: size.width,
                height: size.height * 0.06,
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Color(0xFF3789FF)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if(!_isApiCalled){
                      _verifyOTP();
                    }
                  },
                  child: !_isApiCalled
                      ? AutoSizeText(
                    //'Continue',
                    locator.mLang['continue'],
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  )
                      : SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: size.height * 0.01,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _start = 60;
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    if(_timer != null){
      _timer!.cancel();

    }
    super.dispose();
  }

  Future<void> _verifyOTP() async {
    final userId = widget.userId;
    if(_otp.isEmpty || _otp.length < 4){
      setState(() {
        errorMessage = "invalid otp";
      });
      return;
    }

    setState(() {
      _isApiCalled = true;
      errorMessage = "";
    });

    final response = await locator.verifyOtp(userId,_otp);
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
        if(!widget.isForgot){
          await locator.saveUserInfo(data);
          Navigator.pop(context);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              builder: (context) => EnaamBottomNavScreen()), (Route route) => false);
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgotPasswordUpdateScreen(userId: data['userId'],)),
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
}
