import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../common/enaam_json_parser.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({Key? key}) : super(key: key);

  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  final locator = GetIt.instance<EnaamJsonParser>();

  var _isApiCalled = true;
  var errorMessage = "";

  @override
  void initState() {
    //FlutterNativeSplash.remove();
    _getTickets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: _buildSmallScreen(size)),
    );
  }

  Widget _buildSmallScreen(
    Size size,
  ) {
    return _isApiCalled
        ? _buildSpinner(size)
        : _buildMainBody(
            size,
          );
  }

  Widget _buildSpinner(Size size) {
    return Center(
      child: SizedBox(
        width: size.width * 0.1,
        height: size.width * 0.1,
        child: CircularProgressIndicator(
          color: Colors.white,
          backgroundColor: Color(0xFF516365),
          strokeWidth: 5,
        ),
      ),
    );
  }

  Widget _buildMainBody(
    Size size,
  ) {
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg_gradient.png"),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  //'Tickets',
                  locator.mLang['tickets'],
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
            locator.isUserLoggedIn && locator.mTicketsPage['data']['tickets'].length > 0
                ? Container(
              margin: EdgeInsets.only(top: 20),
                  child: Column(
                  children: locator.mTicketsPage['data']['tickets']
                      .map<Widget>((item) {
                    return Container(
                      width: size.width,
                      height: size.height * 0.12,
                      margin: EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 10),
                      decoration: BoxDecoration(
                          border:
                          Border.all(color: Color(0xffC8C8C8), width: 1),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: size.width * 0.45,
                            padding: EdgeInsetsDirectional.only(top: 10,start: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      margin: EdgeInsets.only(top: 5),
                                      child: Image.asset(
                                        'assets/images/elipses.png',
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsetsDirectional.only(start: 5),
                                        child: Text(
                                          item['title'],
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsetsDirectional.only(top: 10,start: 15),
                                  child: Text(
                                    "" + item['price'].toString(),
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black,
                                        fontSize: 16),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsetsDirectional.only(top: 10,start: 13),
                                  child: Text(
                                    item['purchasedOn'],
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        color: Color(0xff898989),
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: size.width * 0.45,
                              child: Container(
                                width: size.width * 0.18,
                                height: size.width * 0.18,
                                padding: EdgeInsets.all(5),
                                child: CachedNetworkImage(
                                  imageUrl: item['imageURL'],
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList()),
                )
                : Expanded(
                  child: SizedBox(
              height: size.height,
              child: Center(child: Text('No tickets found')),
            ),
                ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

   _getTickets() async {
    if(locator.isUserLoggedIn){
      await locator.readTicketsPage(locator.mProfileDetailPage['userId']);
    }

    setState(() {
      _isApiCalled = false;
    });
  }
}
