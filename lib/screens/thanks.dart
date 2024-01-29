import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'enaam_bottom_nav.dart';

class ThanksScreen extends StatefulWidget {
  const ThanksScreen({Key? key}) : super(key: key);

  @override
  _ThanksScreemState createState() => _ThanksScreemState();
}

class _ThanksScreemState extends State<ThanksScreen> {

  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Colors.blue,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                          builder: (context) => EnaamBottomNavScreen()), (Route route) => false);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 30,horizontal: 30),
                      child: Image.asset(
                        'assets/images/back_icon.png',
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Image.asset(
                  'assets/images/thanks.png',
                ),
              ),

              loginButton(size)
            ],
          ),
        ),
      ),
    );
  }


  Widget loginButton(Size size) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xff0E84C8).withOpacity(1.0),
                Color(0xff26A6DF).withOpacity(1.0)
              ]
          ),
          borderRadius: BorderRadius.circular(8)
      ),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (context) => EnaamBottomNavScreen()), (Route route) => false);
          },
          child: Text('BACK TO HOME', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400
          ),)
      ),
    );
  }
}
