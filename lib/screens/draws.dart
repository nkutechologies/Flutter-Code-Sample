import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:enaam/screens/profile.dart';
import 'package:enaam/screens/register.dart';
import 'package:enaam/screens/youtubescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../common/enaam_json_parser.dart';

class DrawsScreen extends StatefulWidget {
  const DrawsScreen({Key? key}) : super(key: key);

  @override
  _DrawsScreenState createState() => _DrawsScreenState();
}

class _DrawsScreenState extends State<DrawsScreen> {
  final locator = GetIt.instance<EnaamJsonParser>();
  final PageController controller = PageController();

  var _isApiCalled = true;
  var errorMessage = "";
  var totalSwitches = 2;
  var _tabIndex = 0;

  @override
  void initState() {
    //FlutterNativeSplash.remove();
    _getDraws();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
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
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg_gradient.png"),
              fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  //'Live Draws',
                  locator.mLang['live_draws'],
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
            SizedBox(
              height: size.height * 0.03,
            ),
            Container(
                height: locator.mDrawsPage['data'][0]['sectionData'].length > 0 ? size.height * 0.17 : 0,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: locator.mDrawsPage['data'][0]['sectionData'].length > 0
                    ? GridView.builder(
                        itemCount:
                            locator.mDrawsPage['data'][0]['sectionData'].length,
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 0.65,
                            mainAxisSpacing: 10),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => YoutubeScreen(url: locator.mDrawsPage['data'][0]['sectionData'][index]['videoUrl'],)),
                              );
                              await SystemChrome.setPreferredOrientations(([DeviceOrientation.portraitUp]));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xffC8C8C8), width: 1),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      spreadRadius: 0,
                                      blurRadius: 4,
                                      offset: Offset(
                                          0, 4), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Container(
                                    height: size.height * 0.12,
                                    width: size.width,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: locator.mDrawsPage['data'][0]
                                            ['sectionData'][index]['thumbnailImage'],
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: Center(
                                        child: AutoSizeText(
                                          locator.mDrawsPage['data'][0]['sectionData']
                                              [index]['drawDate'] != null ? locator.mDrawsPage['data'][0]['sectionData']
                                          [index]['drawDate'] : '',
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Color(0xff898989),
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : SizedBox()),
            SizedBox(
              height: size.height * 0.04,
            ),
            Container(
              child: ToggleSwitch(
                minWidth: size.width,
                minHeight: size.height * 0.06,
                cornerRadius: 20.0,
                activeBgColors: [[Color(0xff0E84C9)], [Color(0xff0E84C9)]],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.white,
                inactiveFgColor: Colors.black,
                initialLabelIndex: _tabIndex,
                totalSwitches: totalSwitches,
                customTextStyles: [
                  TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                  )
              ],
                labels: [
                  //'Winners',
                  locator.mLang['winners'],
                  //'Upcoming Draws'
                  locator.mLang['upcoming_draws']
                ],
                radiusStyle: true,
                onToggle: (index) {
                  if(_tabIndex != index){
                    setState(() {
                      _tabIndex = index!;
                    });
                    print(index);
                  }
                },
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),


            _tabIndex == 0 && locator.mDrawsPage['data'][1]['sectionData'].length > 0
                ? ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: locator.mDrawsPage['data'][1]['sectionData']
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
                                  imageUrl: item['imageUrl'],
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                )),
                            Container(
                              height: size.height * 0.04,
                              decoration: BoxDecoration(
                                color: Colors.transparent
                              ),
                              child: AutoSizeText(
                                item['title'],
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
                                    text: item['winTitle'] + ' ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black,
                                        fontSize: 20)
                                    ,
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: item['desc'],
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
                                  locator.mLang['ticket_no'],
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
                              height: size.height * 0.02,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: AutoSizeText(
                                  'Announced: ' + item['drawDate'],
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
                            Expanded(child: SizedBox(height: 1,))
                          ],
                        ),
                      );
                    }).toList())
                : SizedBox(),
            _tabIndex == 1 ? Container(
              height: size.height / 2,
              child: Center(
                child: Text(
                    'No record found'
                ),
              ),
            ) : SizedBox()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getDraws() async {
    await locator.readDrawsPage();
    setState(() {
      _isApiCalled = false;
    });
  }
}
