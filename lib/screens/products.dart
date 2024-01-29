import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enaam/screens/login.dart';
import 'package:enaam/screens/productdetail.dart';
import 'package:enaam/screens/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../common/apicalls.dart';
import '../common/enaam_json_parser.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final locator = GetIt.instance<EnaamJsonParser>();
  final locatorAPI = GetIt.instance<ApiCalls>();

  var _isApiCalled = true;
  var errorMessage = "";

  int _currentIndexProducts = -1;



  @override
  void initState() {
    _fetchProducts();
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
                      child: AutoSizeText(
                        //'Products',
                        locator.mLang['products'],
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
                child: locator.mProductsPage['data'].length > 0
                    ? ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: locator.mProductsPage['data']
                        .map<Widget>((item) {
                          final soldByAvailableRatio = item['sold'] / item['quantity'];
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
                                                    item['sold'].toString(),
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
                                                    item['quantity'].toString(),
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
                                          soldByAvailableRatio <= 1 ? Container(
                                            width: size.width * 0.35,
                                            child: LinearPercentIndicator(
                                              lineHeight: 8.0,
                                              percent:
                                              double.parse(item['sold'].toString()) /
                                                  double.parse(
                                                      item['quantity'].toString()),
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
                                        child: item['quantity'] == item['sold'] ? Row(
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
                                                  item['drawDate'] != null ? '${locator.mLang['max_draw_date']}: ' + item['drawDate'] : locator.mLang['max_draw_date'],
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
                                  imageUrl: item['reward']['image'],
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
                                  item['reward']['name'] != null ? locator.mLang['home_win'] + ' ${item['reward']['name']}' : locator.mLang['home_win'],
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
                                  item['reward']['description'],
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
                                    final totalAvailable = item['quantity'];
                                    final totalSold = item['sold'];
                                    if(totalAvailable > totalSold){
                                      int idx = locator.mProductsPage['data'].indexOf(item);
                                      if(_currentIndexProducts == idx){
                                        return;
                                      }
                                      final userId = locator.mProfileDetailPage['userId'];
                                      final productId = item['id'];
                                      final quantity = 1;
                                      _addToCart(userId, productId, quantity,idx);
                                    }

                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                      backgroundColor: item['quantity'] > item['sold'] ? Color(0xFF3789FF) : Colors.grey
                                  ),
                                  child: locator.mProductsPage['data'].indexOf(item) != _currentIndexProducts ? Center(
                                    child: AutoSizeText(
                                      soldByAvailableRatio < 1 ? locator.mLang['add_to_cart'] : locator.mLang['entries_closed'],
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
                                                "id": item['id'],
                                                'imageUrl': item['reward']['image'],
                                                'desc': item['reward']['description'],
                                                'price': item['price'],
                                                'title': item['reward']['name'],
                                                "totalSold": item['sold'],
                                                "totalAvailable": item['quantity'],
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

  Future<void> _fetchProducts() async {

    final response = await locator.readProductsPage();
    print('_fetchProducts | ' + response.toString());

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

  Future<void> _addToCart(userId, productId, quantity, index) async {
    if(locator.isUserLoggedIn){
      setState(() {
        _currentIndexProducts = index;
      });
      final Map<String, dynamic> body = {
        "userId": userId,
        "quantity": quantity,
        "productId": productId,
      };

      print(body);

      final response = await locator.addToCart(body);
      print('Products PAGE | _addToCart | ' + response.toString());
      if(response != null){
        final status = response['status'];
        if(status == 'Success'){
          locator.showCustomSnackBar('Added to cart successfully',context);
        }
      }
      setState(() {
        _currentIndexProducts = -1;
      });
    }
    else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
      );
    }
  }
}
