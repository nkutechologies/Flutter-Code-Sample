import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enaam/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../common/apicalls.dart';
import '../common/enaam_json_parser.dart';

class WinnersScreen extends StatefulWidget {
  const WinnersScreen({Key? key}) : super(key: key);

  @override
  _WinnersScreenState createState() => _WinnersScreenState();
}

class _WinnersScreenState extends State<WinnersScreen> {
  final locator = GetIt.instance<EnaamJsonParser>();
  final locatorAPI = GetIt.instance<ApiCalls>();

  var _isApiCalled = true;
  var errorMessage = "";


  @override
  void initState() {
    _fetchWinners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
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
      child: _isApiCalled ? _buildSpinner(size) : _buildMainBody(
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
                        //'Winners',
                        locator.mLang['winners'],
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
                child: locator.mWinnersPage['data'].length > 0
                    ? ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: locator.mWinnersPage['data']
                        .map<Widget>((item) {
                      return Container(
                        width: size.width,
                        height: size.height * 0.5,
                        margin: EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 10),
                        decoration: BoxDecoration(
                            border:
                            Border.all(color: Color(0xffC8C8C8), width: 1),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset:
                                Offset(0, 4), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Container(
                                width: size.width,
                                height: size.height * 0.25,
                                margin: EdgeInsets.all(10),
                                child: CachedNetworkImage(
                                  imageUrl: item['product']['reward']['image'],
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                )),
                            Container(
                              height: size.height * 0.04,
                              decoration: BoxDecoration(
                                  color: Colors.transparent
                              ),
                              child: AutoSizeText(
                                //'Congratulations',
                                locator.mLang['congratulations'],
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xff3789FF),
                                    fontSize: 30),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              height: size.height * 0.04,
                              decoration: BoxDecoration(
                                  color: Colors.transparent
                              ),
                              child: AutoSizeText(
                                item['winnerName'],
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Color(0xff272D4E),
                                    fontSize: 30),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                                height: size.height * 0.04,
                                decoration: BoxDecoration(
                                    color: Colors.transparent
                                ),
                              child: RichText(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text: locator.mLang['on_winning'] + ' ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black,
                                        fontSize: 20)
                                    ,
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: item['product']['reward']['name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black,
                                            fontSize: 20),
                                      )
                                    ]
                                ),
                              )
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              height: size.height * 0.02,
                              child: Center(
                                child: AutoSizeText(
                                  item['ticket_no'] != null ? 'Ticket no: ' + item['ticket_no'] : '',
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              height: size.height * 0.02,
                              child: Center(
                                child: AutoSizeText(
                                  'Announced: ' + item['announcementDate'],
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList())
                    : SizedBox()
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchWinners() async {

    final response = await locator.readWinnersPage();
    print('_fetchWinners | ' + response.toString());

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
        setState(() {
          _isApiCalled = false;
          errorMessage = '';
        });

        return;
      }
      setState(() {
        _isApiCalled = false;
        errorMessage = message;
      });
    }
  }
}
