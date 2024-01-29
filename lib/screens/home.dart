import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:enaam/screens/login.dart';
import 'package:enaam/screens/productdetail.dart';
import 'package:enaam/screens/products.dart';
import 'package:enaam/screens/profile.dart';
import 'package:enaam/screens/register.dart';
import 'package:enaam/screens/winners.dart';
import 'package:enaam/screens/youtubescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../common/enaam_json_parser.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final locator = GetIt.instance<EnaamJsonParser>();
  final PageController controller = PageController();

  var _isApiCalled = true;
  var errorMessage = "";
  var _isGridOpen = false;

  var _isViewAll = false;

  int _currentIndexGrid = -1;
  int _currentIndexProducts = -1;

  late YoutubePlayerController _controller;

  @override
  void initState() {
    final url = '_x_WFdi4EmA';
    print(url);
    _controller = YoutubePlayerController(
      initialVideoId: url,
      flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          loop: false,showLiveFullscreenButton: false
      ),
    );
    _getHomeData();
    //FlutterNativeSplash.remove();
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
    print(size);
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
              width: size.width,
              height: size.height * 0.35,
              child: Stack(
                children: [
                  /*CachedNetworkImage(
                    imageUrl: locator.mHomePage['data'][0]['section_data'][0]['image_url'],
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),*/
                  !_isGridOpen ? Container(
//                      margin: EdgeInsets.only(top: size.height * 0.1),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5)
                  ),
                      child: CarouselSlider.builder(
                          options: CarouselOptions(
                            height: size.height,
                            initialPage: 0,
                            viewportFraction: 1,
                          ),
                          itemCount:
                          locator.mHomePage['data'][0]['sectionData'].length,
                          itemBuilder: (BuildContext context, int index,
                              int pageViewIndex) {
                            return Padding(
                              padding: const EdgeInsets.all(0),
                              child: Stack(

                                children: [
                                  Container(
                                    width: size.width,
                                    height: size.height,
                                    child: CachedNetworkImage(fit: BoxFit.fill,
                                      imageUrl: locator.mHomePage['data'][0]
                                      ['sectionData'][index]['imageUrl'],
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 30),
                                        height: !locator.isUrdu ? size.height * 0.06 : size.height * 0.09,
                                        width: size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.5)
                                        ),
                                        child: Center(
                                          child: AutoSizeText(
                                            locator.mHomePage['data'][0]
                                            ['sectionData'][index]['desc'],
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 21),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          })) : SizedBox(),
                  /*Center(
                    child: Transform.scale(
                      scaleX: size.width * 0.0029,
                      scaleY: size.width * 0.0035,
                      child: Image.asset(
                        'assets/images/home_header.png',
                      ),
                    ),
                  ),*/
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/enaamlogo.png',
                          width: size.width * 0.3,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  _isGridOpen = !_isGridOpen;
                                });
                              },
                              child: Image.asset(
                                'assets/images/element_3.png',
                                width: size.width * 0.06,
                                height: size.width * 0.06,
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                                );
                              },
                              child: Container(
                                margin: EdgeInsetsDirectional.only(start: 5),
                                child: Image.asset(
                                  'assets/images/profile_circle.png',
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  _isGridOpen ? Container(
                    width: size.width,
                    height: size.height * 0.35,
                    margin: EdgeInsets.only(top: size.height * 0.1),
                    decoration: BoxDecoration(
                      color: Colors.white
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ProductsScreen()),
                            );
                          },
                          child: Container(
                            width: size.width,
                            height: size.height * 0.1,
                            margin: EdgeInsetsDirectional.only(start: 20,end: 20, top: 10),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ],
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                //'Products',
                                locator.mLang['products'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const WinnersScreen()),
                            );
                          },
                          child: Container(
                            width: size.width,
                            height: size.height * 0.1,
                            margin: EdgeInsetsDirectional.only(start: 20,end: 20, top: 15),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ],
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                //'Winners',
                                locator.mLang['winners'],
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ) : SizedBox(),
                ],
              ),
            ),
            Container(
                height: locator.mHomePage['data'][1]['sectionData'].length > 0 ? size.width > 450 ? size.height * 0.33 : size.height * 0.362 : 0,
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: locator.mHomePage['data'][1]['sectionData'].length > 0
                    ? GridView.builder(
                  itemCount:
                  locator.mHomePage['data'][1]['sectionData'].length,
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1.35,
                      mainAxisSpacing: 10),
                  itemBuilder: (BuildContext context, int index) {
                    var sold = locator.mHomePage['data'][1]['sectionData']
                    [index]['totalSold'];
                    var available = locator.mHomePage['data'][1]
                    ['sectionData'][index]['totalAvailable'];
                    final soldConverted = int.parse(sold);
                    final availableConverted = int.parse(available);
                    final double soldByAvailableRatio = soldConverted / availableConverted;
                    if(!_isViewAll && soldByAvailableRatio < 0.7){
                      return SizedBox();
                    }
                    return Container(
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
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: size.height * 0.03,
                            child: AutoSizeText(
                              locator.mHomePage['data'][1]['sectionData']
                              [index]['title'],
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Color(0xff272D4E),
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15),
                            ),
                          ),
                          int.parse(available) >= int.parse(sold) ? Container(
                            width: size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.transparent
                            ) ,
                            child: LinearPercentIndicator(
                              lineHeight: 8.0,
                              percent: soldByAvailableRatio,
                              fillColor: Color(0xffE7E7E7),
                              progressColor: soldByAvailableRatio >= 1 ? Color(0xffFF0000) : soldByAvailableRatio >= 0.7 ? Color(0xffFFB800) : Color(0xff20C344),
                              barRadius: Radius.circular(20),
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              padding: EdgeInsets.symmetric(horizontal: 0.001),
                            ),
                          ) : SizedBox(),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Container(
                            width: size.width * 0.35,
                            height: size.width * 0.2,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: new CachedNetworkImageProvider(locator.mHomePage['data'][1]
                                ['sectionData'][index]['imageUrl']),
                              ),
                            )
                            /*CachedNetworkImage(
                              imageUrl: locator.mHomePage['data'][1]
                              ['sectionData'][index]['imageUrl'],
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),*/
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: size.height * 0.05 ,
                            decoration: BoxDecoration(
                              color: Colors.transparent
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                locator.mHomePage['data'][1]['sectionData']
                                [index]['desc'],
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Rubik',
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: soldByAvailableRatio >= 1 ? size.height * 0.01 : 0,
                          ),
                          soldByAvailableRatio >= 1 ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: size.height * 0.02,
                            decoration: BoxDecoration(
                                color: Colors.transparent
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                'draw date: ' + locator.mHomePage['data'][1]['sectionData']
                                [index]['drawDate'],
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color(0xff6E6E6E),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Rubik',
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12),
                              ),
                            ),
                          ) : SizedBox(),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          locator.isUrdu ? Container(
                            height: size.height * 0.05,
                            decoration: BoxDecoration(
                              color: Colors.transparent
                            ) ,
                            child: ElevatedButton(
                                onPressed: () {
                                  if(int.parse(available) > int.parse(sold)){
                                    if(_currentIndexGrid == index){
                                      return;
                                    }
                                    final userId = locator.mProfileDetailPage['userId'];
                                    final productId = locator.mHomePage['data'][1]['sectionData'][index]['productId'];
                                    final quantity = 1;
                                    _addToCart(userId, productId, quantity,index,true);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                    backgroundColor: int.parse(available) > int.parse(sold) ? Color(0xFF3789FF) : Colors.grey
                                ),
                                child:  _currentIndexGrid != index ? AutoSizeText(
                                  soldByAvailableRatio < 1 ? '  ${locator.mHomePage['data'][1]['sectionData'][index]['buttonTitle']}  ' : '  ${locator.mLang['entries_closed']}  ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15),
                                ) : SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                            ),
                          ) : SizedBox(
                            height: size.height * 0.05,
                            child: ElevatedButton(
                              onPressed: () {
                                if(int.parse(available) > int.parse(sold)){
                                  if(_currentIndexGrid == index){
                                    return;
                                  }
                                  final userId = locator.mProfileDetailPage['userId'];
                                  final productId = locator.mHomePage['data'][1]['sectionData'][index]['productId'];
                                  final quantity = 1;
                                  _addToCart(userId, productId, quantity,index,true);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                  backgroundColor: int.parse(available) > int.parse(sold) ? Color(0xFF3789FF) : Colors.grey
                              ),
                              child: _currentIndexGrid != index ? AutoSizeText(
                                soldByAvailableRatio < 1 ? '  ${locator.mHomePage['data'][1]['sectionData'][index]['buttonTitle']}  ' : '  ${locator.mLang['entries_closed']}  ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15),
                              ) : SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: SizedBox(height: 1,))
                        ],
                      ),
                    );
                  },
                )
                    : SizedBox()),
            !_isViewAll && locator.mHomePage['data'][1]['sectionData'].length > 0 ? Container(
              margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
              child: SizedBox(
                height: size.height * 0.05,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isViewAll = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: Color(0xFF3789FF)
                  ),
                  child: Text(
                    '    VIEW ALL    ',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 15),
                  )
                ),
              ),
            ) : SizedBox(),
            locator.mHomePage['data'][2]['sectionData'].length > 0
                ? Container(
                    height: size.height * 0.2,
                    child: PageView.builder(
                        itemCount:
                            locator.mHomePage['data'][2]['sectionData'].length,
                        pageSnapping: true,
                        itemBuilder: (context, index) {
                          return Container(
                              margin: EdgeInsets.all(10),
                              child: CachedNetworkImage(
                                imageUrl: locator.mHomePage['data'][2]
                                    ['sectionData'][index]['imageUrl'],
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ));
                        }))
                : SizedBox(),
            Container(
              width: size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/how_it_works_back.png"),
                      fit: BoxFit.fill
                  )
              ),
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.08,
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.transparent
                    ),
                    child: Center(
                      child: AutoSizeText(
                        locator.mLang['how_it_works'],
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => YoutubeScreen(url: 'https://www.youtube.com/watch?v=_x_WFdi4EmA',)),
                      );
                      await SystemChrome.setPreferredOrientations(([DeviceOrientation.portraitUp]));
                    },
                    child: Container(
                      height: size.height * 0.28,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.red
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: size.width,
                            child: CachedNetworkImage(
                              imageUrl: 'https://img.youtube.com/vi/_x_WFdi4EmA/0.jpg',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            width: size.width * 0.6,
                            child: Image.asset(
                                'assets/images/youtube_logo.png'
                            ),
                          )
                        ],
                      )
                      /*YoutubePlayerBuilder(
                        onEnterFullScreen: () async {
                          //await SystemChrome.setPreferredOrientations(([DeviceOrientation.landscapeRight]));
                        },
                        onExitFullScreen: () async {
                          //await SystemChrome.setPreferredOrientations(([DeviceOrientation.portraitUp]));
                        },
                        player: YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: false,
                          progressIndicatorColor: Colors.amber,
                          progressColors: ProgressBarColors(
                            playedColor: Colors.amber,
                            handleColor: Colors.amberAccent,
                          ),
                          onReady: () {
                            _controller.addListener(() {});
                          },
                        ),
                        builder: (context, player){
                          return player;
                        },
                      ),*/
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Container(
                    width: size.width,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start ,
                            children: [
                              Container(
                                width: size.width * 0.15,
                                height: size.width * 0.15,
                                child: Image.asset(
                                  'assets/images/how_it_works_1.png',
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsetsDirectional.only(start: 20),
                                  child: AutoSizeText(
                                    locator.mLang['how_it_works_1'],
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start ,
                            children: [
                              Container(
                                width: size.width * 0.15,
                                height: size.width * 0.15,
                                child: Image.asset(
                                  'assets/images/how_it_works_2.png',
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsetsDirectional.only(start: 20),
                                  child: AutoSizeText(
                                    locator.mLang['how_it_works_2'],
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start ,
                            children: [
                              Container(
                                width: size.width * 0.15,
                                height: size.width * 0.15,
                                child: Image.asset(
                                  'assets/images/how_it_works_3.png',
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsetsDirectional.only(start: 20),
                                  child: AutoSizeText(
                                    locator.mLang['how_it_works_3'],
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start ,
                            children: [
                              Container(
                                width: size.width * 0.15,
                                height: size.width * 0.15,
                                child: Image.asset(
                                  'assets/images/how_it_works_4.png',
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsetsDirectional.only(start: 20),
                                  child: AutoSizeText(
                                    locator.mLang['how_it_works_4'],
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start ,
                            children: [
                              Container(
                                width: size.width * 0.15,
                                height: size.width * 0.15,
                                child: Image.asset(
                                  'assets/images/how_it_works_5.png',
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsetsDirectional.only(start: 20),
                                  child: AutoSizeText(
                                    locator.mLang['how_it_works_5'],
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            locator.mHomePage['data'][3]['sectionData'].length > 0
                ? ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: locator.mHomePage['data'][3]['sectionData']
                        .map<Widget>((item) {
                          final totalSold = double.parse(item['totalSold']);
                          final totalAvailable = double.parse(item['totalAvailable']);
                          final soldByAvailableRatio = totalSold / totalAvailable;
                      return Container(
                        width: size.width,
                        height: size.width > 450 ? size.height * 0.65 : size.height * 0.663,
                        margin: EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 10),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Container(
                              width: size.width,
                              height: size.height * 0.07,
                              decoration: BoxDecoration(
                                color: Colors.transparent
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: size.width * 0.4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  AutoSizeText(
                                                    locator.mLang['sold'],
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w400,
                                                        fontStyle: FontStyle.normal,
                                                        fontSize: 10),
                                                  ),
                                                  AutoSizeText(
                                                    item['totalSold'],
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontStyle: FontStyle.normal,
                                                        color: Color(0xff272D4E),
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  AutoSizeText(
                                                    locator.mLang['out_off'],
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w400,
                                                        fontStyle: FontStyle.normal,
                                                        fontSize: 10),
                                                  ),
                                                  AutoSizeText(
                                                    item['totalAvailable'],
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontStyle: FontStyle.normal,
                                                        color: Color(0xff272D4E),
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          totalAvailable >= totalSold ? Container(
                                            width: size.width * 0.35,
                                            child: LinearPercentIndicator(
                                              lineHeight: 8.0,
                                              percent:
                                                  double.parse(item['totalSold']) /
                                                      double.parse(
                                                          item['totalAvailable']),
                                              fillColor: Color(0xffE7E7E7),
                                              progressColor: soldByAvailableRatio >= 1 ? Color(0xffFF0000) : soldByAvailableRatio >= 0.7 ? Color(0xffFFB800) : Color(0xff20C344),
                                              barRadius: Radius.circular(20),
                                              linearStrokeCap:
                                                  LinearStrokeCap.roundAll,
                                              padding:
                                                  EdgeInsets.symmetric(horizontal: 0.001),
                                            ),
                                          ) : SizedBox()
                                        ],
                                      ),
                                    ),
                                     Container(
                                        width: size.width * 0.4,
                                        child: totalAvailable == totalSold ? Row(
                                          children: [
                                            Container(
                                              width: size.width * 0.09,
                                              height: size.width * 0.09,
                                              child: Image.asset(
                                                'assets/images/calender.png',
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsetsDirectional.only(start: 5),
                                                child: AutoSizeText(
                                                  item['max_draw_date'] != null ? '${locator.mLang['max_draw_date']}: ' + item['max_draw_date'] : locator.mLang['max_draw_date'],
                                                  textAlign: TextAlign.start,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontStyle: FontStyle.normal,
                                                      color: Color(0xff272D4E),
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ) : SizedBox())
                                  ],
                                ),
                              ),
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
                              margin: EdgeInsetsDirectional.only(start: 20, end: 20),
                              height: size.height * 0.07,
                              decoration: BoxDecoration(
                                color: Colors.transparent
                              ),
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: AutoSizeText(
                                  item['title'] != null ? locator.mLang['home_win'] + ' ${item['title']}' : locator.mLang['home_win'],
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xffFF2222),
                                      fontSize: 30),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              height: size.height * 0.06,
                              decoration: BoxDecoration(
                                  color: Colors.transparent
                              ),
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: AutoSizeText(
                                  item['desc'],
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      color: Color(0xff272D4E),
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            Container(
                              width: size.width,
                              height: size.height * 0.06,
                              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              child: ElevatedButton(
                                  onPressed: () {
                                    final totalAvailable = int.parse(item['totalAvailable']);
                                    final totalSold = int.parse(item['totalSold']);
                                    if(totalAvailable > totalSold){
                                      int idx = locator.mHomePage['data'][3]['sectionData'].indexOf(item);
                                      if(_currentIndexProducts == idx){
                                        return;
                                      }
                                      final userId = locator.mProfileDetailPage['userId'];
                                      final productId = item['productId'];
                                      final quantity = 1;
                                      _addToCart(userId, productId, quantity,idx,false);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    backgroundColor: int.parse(item['totalAvailable']) > int.parse(item['totalSold']) ? Color(0xFF3789FF) : Colors.grey
                                  ),
                                  child: locator.mHomePage['data'][3]['sectionData'].indexOf(item) != _currentIndexProducts ? Center(
                                    child: AutoSizeText(
                                      soldByAvailableRatio < 1 ? item['buttonTitle'] : locator.mLang['entries_closed'],
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 15),
                                    ),
                                  ) : SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailScreen(
                                              item: {
                                                "id": item['productId'],
                                            'imageUrl': item['imageUrl'],
                                            'desc': item['desc'],
                                            'price': item['price'],
                                            'title': item['title'],
                                            "totalSold": int.parse(item['totalSold']),
                                            "totalAvailable": int.parse(item['totalAvailable']),
                                          }
                                          )
                                  ),
                                );
                              },
                              child: Container(
                                width: size.width,
                                height: size.height * 0.04,
                                padding: EdgeInsets.all(5),
                                child: Center(
                                  child: AutoSizeText(
                                    //'Product Detail',
                                    locator.mLang['product_detail'],
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        color: Color(0xff3789FF),
                                        decoration: TextDecoration.underline,
                                        fontSize: 17),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: SizedBox(height: 1,))
                          ],
                        ),
                      );
                    }).toList())
                : SizedBox()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addToCart(userId, productId, quantity, index, bool isGrid) async {
    if(locator.isUserLoggedIn){
      setState(() {
        if(isGrid){
          _currentIndexGrid = index;
        }
        else{
          _currentIndexProducts = index;
        }
      });
      final Map<String, dynamic> body = {
        "userId": userId,
        "quantity": quantity,
        "productId": productId,
      };

      print(body);

      final response = await locator.addToCart(body);
      print('Home PAGE | _addToCart | ' + response.toString());
      if(response != null){
        final status = response['status'];
        if(status == 'Success'){
          locator.showCustomSnackBar('Added to cart successfully',context);
        }
      }
      setState(() {
        _currentIndexProducts = -1;
        _currentIndexGrid = -1;
      });
    }
    else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
      );
    }
  }

  Future<void> _getHomeData() async {
    await locator.readHomePage();
    setState(() {
      _isApiCalled = false;
    });
  }
}
