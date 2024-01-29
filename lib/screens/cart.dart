import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:enaam/screens/hover_image_game.dart';
import 'package:enaam/screens/profile.dart';
import 'package:enaam/screens/quiz_screen.dart';
import 'package:enaam/screens/register.dart';
import 'package:enaam/screens/terms_conditions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../common/apicalls.dart';
import '../common/enaam_json_parser.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final locator = GetIt.instance<EnaamJsonParser>();
  final locatorAPI = GetIt.instance<ApiCalls>();

  TextEditingController _promocodeController = TextEditingController();

  var _isApiCalled = true;
  var errorMessage = "";
  int _currentIndexGrid = -1;

  @override
  void initState() {
    //FlutterNativeSplash.remove();
    _getCartData();
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
    return locator.isUserLoggedIn
        ? SingleChildScrollView(
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
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Container(
                    height: size.height * 0.25,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffC8C8C8), width: 1),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    //text: 'Total Amount',
                                    text: locator.mLang['total_amount'],
                                    style: TextStyle(
                                        color: Color(0xff272D4E),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                        //text: '(Inc VAT)',
                                        text: locator.mLang['inclusive_of_vat'],
                                        style: TextStyle(
                                            color: Color(0xff272D4E),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ]),
                              ),
                            ),
                            Container(
                              width: size.width * 0.2,
                                child: Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: AutoSizeText(
                              '' +
                                    locator.mCartPage['data']['total'].toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                    color: Color(0xff272D4E),
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold),
                            ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                child: Text(
                              //'Subtotal',
                              locator.mLang['subtotal'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Color(0xff272D4E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            )),
                            Container(
                                child: Text(
                              '' +
                                  locator.mCartPage['data']['subTotal']
                                      .toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Color(0xff272D4E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: size.width * 0.6,
                              height: size.height * 0.06,
                              child: TextFormField(
                                controller: _promocodeController,
                                style: TextStyle(
                                    color: Color(0xFF7D7D7D), fontSize: 15),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  //hintText: 'Promo Code',
                                  hintText: locator.mLang['promo_code'],
                                  hintStyle: TextStyle(
                                      color: Color(0xFF7D7D7D), fontSize: 15),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: Color(0xFFD8D8D8), width: 1),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.25,
                              height: size.height * 0.06,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFF3789FF)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                child: !_isApiCalled
                                    ? Text(
                                        //'Apply',
                                        locator.mLang['apply'],
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
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  locator.mCartPage['data']['products'].length > 0
                      ? Container(
                          height: size.height * 0.26,
                          child: PageView.builder(
                              itemCount:
                                  locator.mCartPage['data']['products'].length,
                              pageSnapping: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xffC8C8C8), width: 1),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          spreadRadius: 0,
                                          blurRadius: 4,
                                          offset: Offset(0,
                                              4), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Container(
                                          height: size.height * 0.1,
                                          child: CachedNetworkImage(
                                            imageUrl: locator.mCartPage['data']
                                                    ['products'][index]
                                                ['productImage'],
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              width: size.width * 0.5,
                                              child: AutoSizeText(
                                                locator.mCartPage['data']
                                                    ['products'][index]['desc'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff272D4E)),
                                              )),
                                          Container(
                                            width: size.width * 0.3,
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (!_isApiCalled) {
                                                      final userId = locator
                                                              .mProfileDetailPage[
                                                          'userId'];
                                                      final productId = locator
                                                                  .mCartPage[
                                                              'data']['products']
                                                          [index]['productId'];
                                                      final quantity = 1;
                                                      _addProductToCart(userId,
                                                          productId, quantity);
                                                    }
                                                  },
                                                  child: Container(
                                                    width: size.width * 0.08,
                                                    height: size.width * 0.08,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                        color:
                                                            Color(0xffEDEDED)),
                                                    child: Center(
                                                      child: IconButton(
                                                        iconSize: 15,
                                                        icon: const Icon(
                                                          Icons.add,
                                                        ),
                                                        // the method which is called
                                                        // when button is pressed
                                                        onPressed: () {
                                                          if (!_isApiCalled) {
                                                            final userId = locator
                                                                    .mProfileDetailPage[
                                                                'userId'];
                                                            final productId = locator
                                                                            .mCartPage[
                                                                        'data']
                                                                    ['products']
                                                                [
                                                                index]['productId'];
                                                            final quantity = 1;
                                                            _addProductToCart(
                                                                userId,
                                                                productId,
                                                                quantity);
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                      locator.mCartPage['data']
                                                              ['products']
                                                              [index]
                                                              ['quantity']
                                                          .toString(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Color(
                                                              0xff272D4E)),
                                                    )),
                                                GestureDetector(
                                                  onTap: () {
                                                    final quantity = locator
                                                                .mCartPage[
                                                            'data']['products']
                                                        [index]['quantity'];
                                                    if (quantity > 1) {
                                                      locator.mCartPage['data']
                                                                  ['products']
                                                              [index]
                                                          ['quantity'] = locator
                                                                          .mCartPage[
                                                                      'data']
                                                                  ['products'][
                                                              index]['quantity'] -
                                                          1;
                                                      setState(() {});
                                                      return;
                                                    }
                                                    if (!_isApiCalled) {
                                                      final userId = locator
                                                              .mProfileDetailPage[
                                                          'userId'];
                                                      final productId = locator
                                                                  .mCartPage[
                                                              'data']['products']
                                                          [index]['productId'];
                                                      _removeFromCart(
                                                          userId, productId);
                                                    }
                                                  },
                                                  child: Container(
                                                    width: size.width * 0.08,
                                                    height: size.width * 0.08,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                        color:
                                                            Color(0xffEDEDED)),
                                                    child: IconButton(
                                                      iconSize: 15,
                                                      icon: const Icon(
                                                        Icons.remove,
                                                      ),
                                                      // the method which is called
                                                      // when button is pressed
                                                      onPressed: () {
                                                        final quantity = locator
                                                                    .mCartPage[
                                                                'data']['products']
                                                            [index]['quantity'];
                                                        if (quantity > 1) {
                                                          locator.mCartPage[
                                                                          'data']
                                                                      ['products']
                                                                  [index][
                                                              'quantity'] = locator
                                                                              .mCartPage[
                                                                          'data']
                                                                      ['products']
                                                                  [
                                                                  index]['quantity'] -
                                                              1;
                                                          setState(() {});
                                                          return;
                                                        }
                                                        if (!_isApiCalled) {
                                                          final userId = locator
                                                                  .mProfileDetailPage[
                                                              'userId'];
                                                          final productId =
                                                              locator.mCartPage[
                                                                          'data']
                                                                      ['products']
                                                                  [
                                                                  index]['productId'];
                                                          _removeFromCart(
                                                              userId,
                                                              productId);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Expanded(
                                        child: Container(
                                            child: Text(
                                          //'1 Ticket Per Unit',
                                          '1 ' +
                                              locator.mLang['ticket_per_unit'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff3789FF)),
                                        )),
                                      ),
                                    ],
                                  ),
                                );
                              }))
                      : SizedBox(),
                  SizedBox(
                    height: 10,
                  ),
                  locator.mProductsPage['data'].length > 0
                      ? Container(
                      height: locator.mProductsPage['data'].length > 0 ? size.width > 450 ? size.height * 0.33 : size.height * 0.362 : 0,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.transparent
                      ),
                      child: locator.mProductsPage['data'].length > 0
                          ? GridView.builder(
                        itemCount:
                        locator.mProductsPage['data'].length,
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 1.35,
                            mainAxisSpacing: 10),
                        itemBuilder: (BuildContext context, int index) {
                          var sold = locator.mProductsPage['data']
                          [index]['sold'];
                          var available = locator.mProductsPage['data'][index]['quantity'];
                          final double soldByAvailableRatio = sold / available;
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
                                    '${sold} Entries out of ${available}',
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
                                available >= sold ? Container(
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
                                        image: new CachedNetworkImageProvider(locator.mProductsPage['data'][index]['reward']['image']),
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
                                      locator.mProductsPage['data']
                                      [index]['reward']['description'],
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
                                      'draw date: ' + locator.mProductsPage['data']
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
                                      if(available > sold){
                                        if(_currentIndexGrid == index){
                                          return;
                                        }
                                        final userId = locator.mProfileDetailPage['userId'];
                                        final productId = locator.mProductsPage['data'][index]['productId'];
                                        final quantity = 1;
                                        _addToCart(userId, productId, quantity,index);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                        backgroundColor: available > sold ? Color(0xFF3789FF) : Colors.grey
                                    ),
                                    child:  _currentIndexGrid != index ? AutoSizeText(
                                      soldByAvailableRatio < 1 ? '  ${locator.mLang['add_to_cart']}  ' : '  ${locator.mLang['entries_closed']}  ',
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
                                        final productId = locator.mProductsPage['data'][index]['productId'];
                                        final quantity = 1;
                                        _addToCart(userId, productId, quantity,index);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                        backgroundColor: available > sold ? Color(0xFF3789FF) : Colors.grey
                                    ),
                                    child: _currentIndexGrid != index ? AutoSizeText(
                                      soldByAvailableRatio < 1 ? '  ${locator.mLang['add_to_cart']}  ' : '  ${locator.mLang['entries_closed']}  ',
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
                          : SizedBox())
                      : SizedBox(),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: size.width,
                    height: size.height * 0.06,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                        if (!_isApiCalled) {
                          _playGame();
                        }
                      },
                      child: !_isApiCalled
                          ? Text(
                              //'PROCEED TO PLAY',
                              locator.mLang['proceed_to_play'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        : Container(
            width: size.width,
            height: size.height,
            child: Center(
              child: Text('No items found'),
            ),
          );
  }

  @override
  void dispose() {
    _promocodeController.dispose();
    super.dispose();
  }

  Future<void> _getCartData() async {
    if (locator.isUserLoggedIn) {
      await locatorAPI.getCartData(locator.mProfileDetailPage['userId']);
      await locator.readProductsPage();
    } else {
      /*WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );
        //Navigator.pop(context);
      });*/
    }
    setState(() {
      _isApiCalled = false;
    });
  }

  Future<void> _addToCart(userId, productId, quantity, index) async {
    setState(() {
      _currentIndexGrid = index;
    });
    final Map<String, dynamic> body = {
      "userId": userId,
      "quantity": quantity,
      "productId": productId,
    };

    print(body);

    final response = await locator.addToCart(body);
    print('Cart PAGE | _addToCart | ' + response.toString());
    if (response != null) {
      final status = response['status'];
      if (status == 'Success') {
        locator.mCartPage = response;
        locator.showCustomSnackBar('Added to cart successfully', context);
      }
    }
    setState(() {
      _currentIndexGrid = -1;
    });
  }

  Future<void> _addProductToCart(userId, productId, quantity) async {
    setState(() {
      _isApiCalled = true;
    });

    final Map<String, dynamic> body = {
      "userId": userId,
      "quantity": quantity,
      "productId": productId,
    };

    final response = await locator.addProductToCart(body);
    if (response != null) {
      final status = response['status'];
      if (status == 'Success') {
        locator.mCartPage = response;
        locator.showCustomSnackBar('Added to cart successfully', context);
      }
    }
    print(response);
    setState(() {
      _isApiCalled = false;
    });
  }

  Future<void> _removeFromCart(userId, productId) async {
    setState(() {
      _isApiCalled = true;
    });

    final Map<String, dynamic> body = {
      "userId": userId,
      "productId": productId,
    };

    final response = await locator.removeFromCart(body);
    //print(response);
    if (response != null) {
      final status = response['status'];
      if (status == 'Success') {
        locator.mCartPage = response;
        locator.showCustomSnackBar('Removed from cart successfully', context);
      }
    }
    setState(() {
      _isApiCalled = false;
    });
  }

  Future<void> _playGame() async {
    final gameType = locator.mCartPage['data']['gameType'];
    //final gameType = 'BALL_GAME';
    final products = locator.mCartPage['data']['products'];
    if (products.length == 0) {
      locator.showCustomSnackBarError(
          'Your cart is empty. You cannot proceed', context);
      return;
    }
    //final gameType = 'MCQ';
    if (gameType == 'BALL_GAME') {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HoverImageGame(
                  locator: locator,
                )),
      );
      setState(() {});
    } else if (gameType == 'MCQ') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TermsAndConditionsScreen()),
      );
    }
  }
}
