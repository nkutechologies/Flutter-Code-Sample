import 'package:cached_network_image/cached_network_image.dart';
import 'package:enaam/main.dart';
import 'package:enaam/screens/changepassword.dart';
import 'package:enaam/screens/enaam_bottom_nav.dart';
import 'package:enaam/screens/enaam_webview.dart';
import 'package:enaam/screens/forgotpassword.dart';
import 'package:enaam/screens/personaldetails.dart';
import 'package:enaam/screens/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/apicalls.dart';
import '../common/enaam_json_parser.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final locator = GetIt.instance<EnaamJsonParser>();
  final locatorAPI = GetIt.instance<ApiCalls>();

  var _isApiCalled = true;
  var errorMessage = "";

  var profileImage = '';

  PickedFile? image;

  final ImagePicker picker = ImagePicker();
  final List<String> _langList = [
    'English',
    'Urdu',
  ];

  String? _langSelectedValue;

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.getImage(source: media);
    if (img != null) {
      setState(() {
        _isApiCalled = true;
      });
      final response = await locatorAPI.updateProfilePicture(
          img, locator.mProfileDetailPage['userId']);
      if (response != null) {
        final status = response["status"];
        final message = response["message"];

        //print('_registerUser | ' + status);

        if (status == null || message == null) {
          setState(() {
            _isApiCalled = false;
            errorMessage = "Something went wrong. Please try again";
          });
          return;
        }
        if (status == 'Success') {
          locator.mProfileDetailPage = response['data'];
          profileImage = response['data']['profileImage'];
        }
      }
      setState(() {
        _isApiCalled = false;
      });
    }
  }

  @override
  void initState() {
    //FlutterNativeSplash.remove();
    profileImage = locator.mProfileDetailPage['profileImage'] != null
        ? locator.mProfileDetailPage['profileImage']
        : 'https://i.ibb.co/n7MXwD8/user-profile.png';
    _getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: _buildSmallScreen(size)),
      ),
    );
  }

  Widget _buildSmallScreen(
    Size size,
  ) {
    return Center(
      child: !_isApiCalled ? _buildMainBody(
        size,
      ) : _buildSpinner(size),
    );
  }

  Widget _buildSpinner(Size size) {
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
    return Container(
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
            width: size.width,
            height: size.height * 0.35,
            decoration: BoxDecoration(color: Colors.transparent),
            child: Stack(
              children: [
                Container(
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          getImage(ImageSource.gallery);
                        },
                        child: Container(
                          width: size.width * 0.35,
                          height: size.width * 0.35,
                          child: !_isApiCalled
                              ? CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: NetworkImage(profileImage),
                                  backgroundColor: Colors.white,
                                )
                              : Center(
                                  child: SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          locator.mProfilePage['data'][0]['sectionData'][0]
                              ['title'],
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color(0xff272D4E),
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontSize: 24),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          locator.mProfilePage['data'][0]['sectionData'][0]
                          ['email'] != null ? locator.mLang['email'] + ": " +
                              locator.mProfilePage['data'][0]['sectionData'][0]
                                  ['email'] : '',
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color(0xff272D4E),
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      child: Image.asset(
                        'assets/images/back_icon.png',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 5),
            margin: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Color(0xffD7E4F9).withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 52.85,
                  offset: Offset(0, 18), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PersonalDetailsScreen()),
                    );
                    setState(() {

                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Image.asset(
                                'assets/images/user.png',
                              ),
                              /*CachedNetworkImage(
                            imageUrl: locator.mProfilePage['data'][1]
                                ['sectionData'][0]['image_url_pd'],
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),*/
                            ),
                            Container(
                              child: Text(
                                locator.mProfilePage['data'][1]['sectionData']
                                    [0]['title_pd'],
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color(0xff272D4E),
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsetsDirectional.only(end: 20),
                          child: Image.asset(
                            'assets/images/icon_forward.png',
                          ),
                          /*CachedNetworkImage(
                            imageUrl: locator.mProfilePage['data'][1]
                                ['sectionData'][0]['image_url_pd'],
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),*/
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: Color(0xffE3E3E3),
                ),
                GestureDetector(
                  onTap: () async {
                    await locator.logoutUser();
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context) => RegisterScreen()), (Route route) => false);
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Image.asset(
                                'assets/images/logout.png',
                              ),
                              /*CachedNetworkImage(
                            imageUrl: locator.mProfilePage['data'][1]
                                ['sectionData'][0]['image_url_pd'],
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),*/
                            ),
                            Container(
                              child: Text(
                                locator.mProfilePage['data'][1]['sectionData']
                                    [0]['title_log'],
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color(0xff272D4E),
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsetsDirectional.only(end: 20),
                          child: Image.asset(
                            'assets/images/icon_forward.png',
                          ),
                          /*CachedNetworkImage(
                            imageUrl: locator.mProfilePage['data'][1]
                                ['sectionData'][0]['image_url_pd'],
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),*/
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: Color(0xffE3E3E3),
                ),
                GestureDetector(onTap: (){
                  _showLangList(size);
                },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Image.asset(
                                'assets/images/book.png',
                              ),
                            ),
                            Container(
                              child: Text(
                                locator.mProfilePage['data'][1]['sectionData'][0]
                                    ['title_lng'],
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color(0xff272D4E),
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsetsDirectional.only(end: 20),
                          child: Image.asset(
                            'assets/images/icon_forward.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: Color(0xffE3E3E3),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Image.asset(
                                'assets/images/lock_circle.png',
                              ),
                              /*CachedNetworkImage(
                            imageUrl: locator.mProfilePage['data'][1]
                                ['sectionData'][0]['image_url_pd'],
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),*/
                            ),
                            Container(
                              child: Text(
                                locator.mProfilePage['data'][1]['sectionData']
                                    [0]['title_chng'],
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color(0xff272D4E),
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsetsDirectional.only(end: 20),
                          child: Image.asset(
                            'assets/images/icon_forward.png',
                          ),
                          /*CachedNetworkImage(
                            imageUrl: locator.mProfilePage['data'][1]
                                ['sectionData'][0]['image_url_pd'],
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),*/
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: size.width,
            height: size.height * 0.08,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(color: Colors.transparent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: size.height * 0.06,
                  width: size.width * 0.4,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            width: 1.0,
                            color: Color(0xff3789FF),
                          )),
                      onPressed: () async {
                        var url = 'tel:' +
                            locator.mProfilePage['data'][2]['sectionData'][0]
                                ['c_phone'];
                        Uri phoneno = Uri.parse(url);

                        if (await launchUrl(phoneno)) {
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text(
                        '  ${locator.mProfilePage['data'][2]['sectionData'][0]['btn1_title']}  ',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            color: Color(0xff3789FF),
                            fontSize: 15),
                      )),
                ),
                Container(
                  height: size.height * 0.06,
                  width: size.width * 0.4,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            width: 1.0,
                            color: Color(0xff3789FF),
                          )),
                      onPressed: () async {
                        var url = 'mailto:' + locator.mProfilePage['data'][2]['sectionData'][0]
                            ['c_email'];
                        Uri email = Uri.parse(url);

                        if (await launchUrl(email)) {
                        } else {
                        throw 'Could not launch $url';
                        }
                      },
                      child: Text(
                        '  ${locator.mProfilePage['data'][2]['sectionData'][0]['btn2_title']}  ',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            color: Color(0xff3789FF),
                            fontSize: 15),
                      )),
                )
              ],
            ),
          ),
          Container(
            width: size.width,
            height: size.height * 0.09,
            decoration: BoxDecoration(color: Colors.transparent),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    print('facebook url ' + Uri.encodeFull(locator.mProfilePage['data'][3]
                    ['sectionData'][0]['facebook']));
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnaamWebview(url: locator.mProfilePage['data'][3]
                          ['sectionData'][0]['facebook'])),
                    );*/
                    _launchUrl(locator.mProfilePage['data'][3]
                    ['sectionData'][0]['facebook']);
                    
                  },
                  child: Container(
                    width: size.width * 0.11,
                    height: size.width * 0.11,
                    child: Image.asset(
                      'assets/images/facebook.png',
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    /*_launchUrl(Uri.parse(locator.mProfilePage['data'][3]
                        ['sectionData'][0]['twitter']));*/
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnaamWebview(url: locator.mProfilePage['data'][3]
                          ['sectionData'][0]['twitter'])),
                    );
                  },
                  child: Container(
                    width: size.width * 0.11,
                    height: size.width * 0.11,
                    child: Image.asset(
                      'assets/images/twitter.png',
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    _launchUrl(locator.mProfilePage['data'][3]
                        ['sectionData'][0]['whatsapp']);
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnaamWebview(url: "https://www." + locator.mProfilePage['data'][3]
                          ['sectionData'][0]['whatsapp'])),
                    );*/
                  },
                  child: Container(
                    width: size.width * 0.11,
                    height: size.width * 0.11,
                    child: Image.asset(
                      'assets/images/whatsapp.png',
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    /*_launchUrl(Uri.parse(locator.mProfilePage['data'][3]
                        ['sectionData'][0]['instgram']));*/
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnaamWebview(url: locator.mProfilePage['data'][3]
                          ['sectionData'][0]['instgram'])),
                    );
                  },
                  child: Container(
                    width: size.width * 0.11,
                    height: size.width * 0.11,
                    child: Image.asset(
                      'assets/images/instagram.png',
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    //_launchUrl('https://www.youtube.com/@enaampk');
                    _launchUrl(locator.mProfilePage['data'][3]
                    ['sectionData'][0]['youtube']);
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnaamWebview(url: 'https://www.youtube.com/@enaampk')),
                    );*/
                  },
                  child: Container(
                    width: size.width * 0.11,
                    height: size.width * 0.11,
                    child: Image.asset(
                      'assets/images/icon_youtube.png',
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _launchUrl(url) async {
    if (!await launch(url,forceWebView: false)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _getProfileData() async {
    if(locator.isUserLoggedIn){
      await locator.readProfilePage(locator.mProfileDetailPage['userId']);
      setState(() {
        _isApiCalled = false;
      });
    }
    else{
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );
        Navigator.pop(context);
      });
    }
  }

  void _showLangList(Size size) {
    showModalBottomSheet(
      context: context,

      // backgroundColor: Colors.transparent,
      builder: (context) => Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                if(locator.isUrdu){
                  if(!_isApiCalled){
                    setState(() {
                      _isApiCalled = true;
                    });
                    await locator.saveLangPreference('en');
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context) => EnaamBottomNavScreen()), (Route route) => false);
                    /*setState(() {
                      _isApiCalled = false;
                    });*/
                  }
                }
              },
              child: Container(
                height: size.height * 0.06,
                child: Center(
                  child: Text(
                    locator.mLang['language_en'],
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
            ),
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                if(!locator.isUrdu){
                  if(!_isApiCalled){
                    setState(() {
                      _isApiCalled = true;
                    });
                    await locator.saveLangPreference('ur');
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context) => EnaamBottomNavScreen()), (Route route) => false);
                    /*setState(() {
                      _isApiCalled = false;
                    });*/
                  }
                }
              },
              child: Container(
                height: size.height * 0.06,
                child: Center(
                  child: Text(
                      locator.mLang['language_ur'],
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
