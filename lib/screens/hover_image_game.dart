import 'package:enaam/common/service_locator.dart';
import 'package:enaam/screens/enaam_webview.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as ModelSheet;
import '../common/enaam_json_parser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HoverImageGame extends StatefulWidget {
  EnaamJsonParser locator;
  HoverImageGame({Key? key, required this.locator}) : super(key: key);
  @override
  _HoverImageGameState createState() => _HoverImageGameState();
}

class _HoverImageGameState extends State<HoverImageGame> {
  ScrollController _scrollController = ScrollController();
  double _circleX = 0;
  double _circleY = 0;
  double _imageWidth = 0;
  double _imageHeight = 0;
  bool _imageLoaded = false;
  ImageStream? _imageStream;
  ImageInfo? _imageInfo;
  bool showCheckout = false;
  int _selectedIndex = 0;
  int _selectedItemCount = 0;
  bool _isApiCalled = false;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  var _imageDataList;
  final List<int> visitedIndices = [];

  // void selectItem(index) {
  //   setState(() {
  //     visitedIndices.add(index);
  //   });
  // }

  // List<String> _imageDataList = [
  //   "assets/images/MG-HS-car 2.png",
  //   "assets/images/MG-HS-car 2.png",
  // ];

  List<Offset> _iconPositions = [];
  void _addIcon() {
    setState(() {
      _iconPositions.add(Offset(_circleX, _circleY));
    });
  }

  void _removeIcon() {
    setState(() {
      _iconPositions.removeLast();
    });
  }

  void _scrollToCell(indexToScroll) {
    itemScrollController.scrollTo(
        index: indexToScroll,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOutCubic);
    setState(() {
      visitedIndices.add(indexToScroll - 1);
    });
  }

  void _scrollToCellOnUndo(indexToScroll) {
    itemScrollController.scrollTo(
        index: indexToScroll,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOutCubic);
    setState(() {
      visitedIndices.removeLast();
    });
  }

  @override
  void initState() {
    super.initState();
    // Set up the ImageStream and ImageStreamListener to get the image width and height
    _imageDataList = widget.locator.mCartPage['data']['products'];
    final imageProvider = AssetImage('assets/images/hover_image.png');
    _imageStream = imageProvider.resolve(ImageConfiguration.empty);
    _imageStream!.addListener(
        ImageStreamListener((ImageInfo info, bool synchronousCall) {
          if (!_imageLoaded) {
            _imageLoaded = true;
            _imageInfo = info;
            _imageWidth = info.image.width.toDouble();
            _imageHeight = info.image.height.toDouble();
            setState(() {});
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final mainImageWidth = MediaQuery.of(context).size.width;
    final mainImageHeight = 320.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: !_isApiCalled ? Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg_gradient.png"),
                fit: BoxFit.fill),
          ),
          child: Column(
            children: [
              Column(
                children: [
                  Stack(
                    children: <Widget>[
                      // Main image
                      SizedBox(
                        width: mainImageWidth,
                        height: mainImageHeight,
                        child: Image.asset(
                          'assets/images/hover_image.png',
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.medium,
                        ),
                      ),

                      // Circle image that can be dragged
                      Positioned(
                        left: _circleX.clamp(0, mainImageWidth - 50),
                        top: _circleY.clamp(0, mainImageHeight - 50),
                        child: GestureDetector(
                          child: Image.asset('assets/images/hover_circle.png'),
                          onPanUpdate: (DragUpdateDetails details) {
                            final x = details.delta.dx;
                            final y = details.delta.dy;
                            if((x + _circleX) < 0 || (y + _circleY) < 0){
                              return;
                            }
                            /*if((x + _circleX) > 0 || (y + _circleY) < 0){
                              return;
                            }*/

                            print(x);
                            print(y);
                            /*if(_circleX < 0 || _circleY < 0){
                              return;
                            }*/
                            setState(() {

                              _circleX += details.delta.dx;
                              _circleY += details.delta.dy;
                            });
                            //print(_circleX);
                          },
                        ),
                      ),

                      ..._iconPositions.map((position) {
                        // Create list of icons at each position in _iconPositions list
                        return Positioned(
                          left: position.dx + 25,
                          top: position.dy + 25,
                          child: const Icon(
                            Icons.add,
                            color: Color.fromARGB(255, 180, 141, 25),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                  Container(
                    color: Colors.white,
                    height: 44,
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        /*IconButton(
                          onPressed: () {},
                          iconSize: 24,
                          icon: Image.asset(
                            'assets/images/edit.png',
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          iconSize: 24,
                          icon: Image.asset(
                            'assets/images/eye-slash.png',
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          iconSize: 24,
                          icon: Image.asset(
                            'assets/images/undo.png',
                          ),
                        ),*/
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          iconSize: 24,
                          icon: Image.asset(
                            'assets/images/login.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: PageStorage(
                  bucket: PageStorageBucket(),
                  child: ScrollablePositionedList.builder(
                    itemScrollController: itemScrollController,
                    itemPositionsListener: itemPositionsListener,
                    scrollDirection: Axis.horizontal,
                    itemCount: _imageDataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var cartProduct = _imageDataList[index];
                      final isSelected = visitedIndices.contains(index);
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          width: MediaQuery.of(context).size.width - 50,
                          // height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            // _selectedIndex == index
                            //     ? Colors.blue[100]
                            //     : Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text('' + cartProduct["name"]),
                                        SizedBox(height: 2),
                                        Text(
                                          'X: ${_circleX.toInt()} Y: ${_circleY.toInt()}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: HexColor("#3789FF")),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Image.asset(
                                      'assets/images/select_tick.png',
                                      fit: BoxFit.cover,
                                      color: isSelected
                                      //  _selectedIndex == index
                                          ? Colors.green
                                          : null,
                                      height: 30,
                                      width: 30,
                                      filterQuality: FilterQuality.medium,
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 120,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.medium,
                                    imageUrl: cartProduct["productImage"],
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                                // SizedBox(
                                //   // width: 200,
                                //   height: 100,
                                //   child: Image.asset(
                                //     cartProduct["productImage"],
                                //     fit: BoxFit.cover,
                                //     filterQuality: FilterQuality.medium,
                                //   ),
                                // ),
                                // const SizedBox(height: 8),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (_selectedItemCount > 0) {
                                            setState(() {
                                              _selectedItemCount--;
                                              showCheckout = false;
                                            });
                                            _scrollToCellOnUndo(_selectedItemCount);
                                            _removeIcon();
                                          }
                                        },
                                        iconSize: 24,
                                        icon: Image.asset(
                                          'assets/images/rotate_left.png',
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (!_isApiCalled) {
                                            final userId = widget.locator
                                                .mProfileDetailPage[
                                            'userId'];
                                            final productId = cartProduct['productId'];
                                            final quantity = 1;
                                            _addProductToCart(userId,
                                                productId, quantity);
                                          }
                                        },
                                        iconSize: 24,
                                        icon: Image.asset(
                                          'assets/images/add_blue.png',
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          final quantity =
                                          widget.locator.mCartPage['data']
                                          ['products'][index]
                                          ['quantity'];
                                          if (quantity > 1) {
                                            widget.locator.mCartPage['data']
                                            ['products'][index]
                                            ['quantity'] =
                                                widget.locator.mCartPage['data']
                                                ['products']
                                                [index]
                                                ['quantity'] -
                                                    1;
                                            setState(() {});
                                            return;
                                          }
                                          if (!_isApiCalled) {
                                            final userId =
                                            widget.locator.mProfileDetailPage[
                                            'userId'];
                                            final productId = cartProduct['productId'];
                                            _removeFromCart(
                                                userId, productId);
                                          }
                                        },
                                        iconSize: 24,
                                        icon: Image.asset(
                                          'assets/images/trash.png',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  width: size.width,
                  height: size.height * 0.06,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                        if (_selectedItemCount < _imageDataList.length) {
                          setState(() {
                            _selectedItemCount++;
                            if (_selectedItemCount == _imageDataList.length) {
                              showCheckout = true;
                            }
                          });
                          _scrollToCell(_selectedItemCount);
                          _addIcon();
                        } else {
                          _checkout(size);
                        }
                      },
                      child: Text(
                        showCheckout == true ? 'CHECKOUT' : 'PLACE',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      )),
                ),
              ),
            ],
          ),
        ) : Center(
          child: SizedBox(
          width: size.width * 0.1,
          height: size.width * 0.1,
          child: CircularProgressIndicator(
            color: Colors.white,
            backgroundColor: Color(0xFF516365),
            strokeWidth: 5,
          ),
      ),
        )
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the ImageStream when the widget is disposed
    _imageStream?.removeListener(
        ImageStreamListener((ImageInfo info, bool synchronousCall) {}));
    super.dispose();
  }

  void _checkout(Size size) {
    showModalBottomSheet(
      context: context,

      // backgroundColor: Colors.transparent,
      builder: (context) => Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                if(!_isApiCalled){
                  Navigator.pop(context);
                  _processPayment('MWALLET');
                }

              },
              child: Row(
                children: [
                  Container(
                    width: size.width * 0.15,
                    height: size.width * 0.15,
                    margin: EdgeInsets.only(left: 20),
                    child: Image.asset(
                      'assets/images/jazzcash.png',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Jazzcash',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                if(!_isApiCalled){
                  Navigator.pop(context);
                  _processPayment('MPAY');
                }

              },
              child: Row(
                children: [
                  Container(
                    width: size.width * 0.15,
                    height: size.width * 0.15,
                    margin: EdgeInsets.only(left: 20),
                    child: Image.asset(
                      'assets/images/card.png',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Credit/Debit Card',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
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

  Future<void> _processPayment(String type) async {
    setState(() {
      _isApiCalled = true;
    });

    final userId = widget.locator.mProfileDetailPage['userId'];
    final products = widget.locator.mCartPage['data']['products'];
    final amount = widget.locator.mCartPage['data']['total'];

    final Map<String, dynamic> productsData = {

    };

    /*print(_iconPositions.toString());
    return;*/

    for(int i=0; i < products.length; i++){
      productsData[products[i]['productId'].toString()] = products[i]['quantity'];
    }
    var answer = '';
    for(int i=0; i < _iconPositions.length; i++){
      answer = answer + "x=" + _iconPositions[i].dx.toString() + ",y=" + _iconPositions[i].dy.toString();
      if((i + 1) < _iconPositions.length){
        answer = answer + "|";
      }
    }

    /*print(answer);
    return;*/

    final Map<String, dynamic> body = {
      "txnType": type,
      "userId": userId,
      "amount": amount,
      "products": productsData,
      "answer": answer,
    };

    print(body);
    final response = await widget.locator.processPayment(body);

    setState(() {
      _isApiCalled = false;
    });

    if (response != null) {
      final status = response["status"];
      if (status == 'Success') {
        final url = response['data'];
        print(url);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EnaamWebview(url: url.toString())),
        );
      }
    }
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

    final response = await widget.locator.addProductToCart(body);
    if(response != null){
      final status = response['status'];
      if(status == 'Success'){
        widget.locator.mCartPage = response;
        widget.locator.showCustomSnackBar('Added to cart successfully',context);
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

    final response = await widget.locator.removeFromCart(body);
    //print(response);
    if(response != null){
      final status = response['status'];
      if(status == 'Success'){
        widget.locator.mCartPage = response;
        _imageDataList = response['data']['products'];
        widget.locator.showCustomSnackBar('Removed from cart successfully',context);
      }
    }
    setState(() {
      _isApiCalled = false;
    });
  }
}