import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:enaam/screens/enaam_bottom_nav.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get_it/get_it.dart';

import '../common/enaam_json_parser.dart';
import '../screens/forgotpasswordupdate.dart';

class EnaamLangPopup extends StatefulWidget {
  const EnaamLangPopup({Key? key,}) : super(key: key);

  @override
  _EnaamLangPopupState createState() => _EnaamLangPopupState();
}

class _EnaamLangPopupState extends State<EnaamLangPopup> {
  final locator = GetIt.instance<EnaamJsonParser>();

  String _language = 'English';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: Container(
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
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),
            Container(
              width: size.width * 0.25,
              height: size.width * 0.25,
              decoration: BoxDecoration(
                color: Colors.transparent
              ),
              child: Image.asset(
                'assets/images/language_logo.png',
              )
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Container(
              height: size.height * 0.04,
              decoration: BoxDecoration(
                color: Colors.transparent
              ),
              child: AutoSizeText(
                locator.mLang['select_language'],
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              height: size.height * 0.08,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder( //<-- SEE HERE
                    borderSide: BorderSide(color: Color(0xffD3D3D3), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder( //<-- SEE HERE
                    borderSide: BorderSide(color: Color(0xffD3D3D3), width: 1),
                  ),
                  filled: true,
                  fillColor: Color(0xffF2F2F2),
                ),
                dropdownColor: Colors.white,
                value: _language,
                onChanged: (String? newValue) {
                  setState(() {
                    _language = newValue!;
                  });
                },
                items: <String>[locator.mLang['language_en'],locator.mLang['language_ur'],].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: AutoSizeText(
                      value,
                      maxLines: 1,
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              width: size.width,
              height: size.height * 0.06,
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
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
                onPressed: () async {
                  locator.isLanguageEmpty = false;
                  if(_language == 'English'){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context) => EnaamBottomNavScreen()), (Route route) => false);
                    return;
                  }
                  await locator.saveLangPreference('ur');
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context) => EnaamBottomNavScreen()), (Route route) => false);

                },
                child: Center(
                  child: AutoSizeText(
                    //'Continue',
                    locator.mLang['continue'],
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Container(
              height: size.height * 0.06,
              width: size.width,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.transparent
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: size.width * 0.1,
                      height: size.width * 0.1,
                      decoration: BoxDecoration(
                          color: Colors.transparent
                      ),
                      child: Image.asset(
                        'assets/images/amanah_icon.png',
                      )
                  ),
                  Container(
                    child: AutoSizeText(
                      //'Continue',
                      locator.mLang['powered_by_amanah'],
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
