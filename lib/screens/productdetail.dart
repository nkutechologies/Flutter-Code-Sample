import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enaam/common/service_locator.dart';
import 'package:enaam/screens/login.dart';
import 'package:enaam/screens/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../common/apicalls.dart';
import '../common/enaam_json_parser.dart';

class ProductDetailScreen extends StatefulWidget {
  final item;
  const ProductDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final locator = GetIt.instance<EnaamJsonParser>();

  bool _isApiCalled = false;
  @override
  void initState() {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
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
                        //'Product Details',
                        locator.mLang['product_detail'],
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
                  width: size.width,
                  height: size.height * 0.3,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: CachedNetworkImage(
                    imageUrl: widget.item['imageUrl'],
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error),
                  )),
              Container(
                  width: size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: '1 Ticket ',
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                          fontSize: 22)
                        ,
                        children: <InlineSpan>[
                          TextSpan(
                            text: 'Rs. ${widget.item['price']}',
                            style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                          )
                        ]
                    ),
                  )
              ),
              Container(
                width: size.width,
                height: size.height * 0.06,
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    final totalAvailable = widget.item['totalAvailable'];
                    final totalSold = widget.item['totalSold'];
                    if(totalAvailable > totalSold){
                      final userId = locator.mProfileDetailPage['userId'];
                      final productId = widget.item['id'];
                      final quantity = 1;
                      _addToCart(userId, productId, quantity);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      /*shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),*/
                      backgroundColor: widget.item['totalAvailable'] > widget.item['totalSold'] ? Color(0xFF3789FF) : Colors.grey
                  ),
                  child: !_isApiCalled ? Center(
                    child: AutoSizeText(
                      widget.item['totalAvailable'] > widget.item['totalSold'] ? locator.mLang['add_to_cart'] : locator.mLang['entries_closed'],
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
              Container(
                margin: EdgeInsetsDirectional.only(top: 15,start: 20,end: 20),
                child: Center(
                  child: AutoSizeText(
                    //'Product Description',
                    widget.item['title'],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        color: Color(0xffFF2222),
                        fontSize: 24),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsetsDirectional.only(top: 15,start: 20, end: 20),
                child: Text(
                  widget.item['desc'],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      color: Color(0xff272D4E),
                      fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addToCart(userId, productId, quantity) async {
    if(locator.isUserLoggedIn){
      setState(() {
        _isApiCalled = true;
      });
      final Map<String, dynamic> body = {
        "userId": userId,
        "quantity": quantity,
        "productId": productId,
      };

      print(body);

      final response = await locator.addToCart(body);
      print('Product Prize PAGE | _addToCart | ' + response.toString());
      if(response != null){
        final status = response['status'];
        if(status == 'Success'){
          locator.showCustomSnackBar('Added to cart successfully',context);
          widget.item['totalSold'] = widget.item['totalSold'] + 1;
        }
      }
      setState(() {
        _isApiCalled = false;
      });
    }
    else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
