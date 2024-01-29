import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../service/nav_service.dart';
import 'apicalls.dart';

class EnaamJsonParser{
  var mJson = {};
  var mHomePage = {};
  var mNotificationPage = {};
  var mProfilePage = {};
  var mProfileDetailPage = {};
  var mTicketsPage = {};
  var mDrawsPage = {};
  var mCartPage = {};
  var mProductsPage = {};
  var mWinnersPage = {};
  var mLang = {};
  late SharedPreferences prefs;
  Map<String,String>? headers = {

  };

  bool isObscure = true;

  var isUserLoggedIn = false;
  var isUrdu = false;
  var isLanguageEmpty = false;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    await getUserInfo();
    await readJson();
    await getLang();
    await checkIfFirstLanding();
    headers = {
      "Content-Type": "application/json",
      "Accept-Language":  prefs.getString('lang')!,
    };
    //await readHomePage();
    //await readNotificationPage();
    //await readTicketsPage();
    //await readDrawsPage();
    //await jsonLocator.readCartPage();
    //await readProductsPage();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/files/config_en.json');
    mJson = json.decode(response);
  }

  Future<void> readHomePage() async {
    //final String response = await rootBundle.loadString('assets/files/home.json');
    final locatorAPI = GetIt.instance<ApiCalls>();
    //mHomePage = json.decode(response);
    mHomePage = await locatorAPI.getHomePageData();
    print('readHomePage | ' + mHomePage.toString());
    //print('mhomepage | ' + mHomePage.toString());
  }

  Future<void> readNotificationPage() async {
    /*final String response = await rootBundle.loadString('assets/files/notifications.json');
    mNotificationPage = json.decode(response);*/
    final locatorAPI = GetIt.instance<ApiCalls>();
    mNotificationPage = await locatorAPI.getNotificationPageData();
  }

  Future readProfilePage(userId) async {
    final locatorAPI = GetIt.instance<ApiCalls>();
    mProfilePage = await locatorAPI.getProfileData(userId);
    /*final String response = await rootBundle.loadString('assets/files/profile.json');
    mProfilePage = json.decode(response);*/
  }

  Future generateOtp(userId) async {
    final locatorAPI = GetIt.instance<ApiCalls>();
    return await locatorAPI.generateOTP(userId);
  }

  Future verifyOtp(userId,otp) async {
    final locatorAPI = GetIt.instance<ApiCalls>();
    return await locatorAPI.verifyOTP(userId,otp);
  }

  Future forgotPassUpdate(body) async {
    final locatorAPI = GetIt.instance<ApiCalls>();
    return await locatorAPI.forgotPassUpdate(body);
  }

  Future processPayment(body) async {
    final locatorAPI = GetIt.instance<ApiCalls>();
    return await locatorAPI.processPayment(body);
  }

  Future readTicketsPage(userId) async {
    /*final String response = await rootBundle.loadString('assets/files/tickets.json');
    mTicketsPage = json.decode(response);*/
    final locatorAPI = GetIt.instance<ApiCalls>();
    mTicketsPage = await locatorAPI.getTicketsPageData(userId);
    return mTicketsPage;
  }

  Future<void> readDrawsPage() async {
    /*final String response = await rootBundle.loadString('assets/files/draws.json');
    mDrawsPage = json.decode(response);*/
    final locatorAPI = GetIt.instance<ApiCalls>();
    mDrawsPage = await locatorAPI.getDrawsPageData();
    print(mDrawsPage);

  }

  Future<void> readCartPage() async {
    final String response = await rootBundle.loadString('assets/files/cart.json');
    mCartPage = json.decode(response);
  }

  Future readProductsPage() async {
    /*final String response = await rootBundle.loadString('assets/files/products.json');
    mProductsPage = json.decode(response);*/
    final locatorAPI = GetIt.instance<ApiCalls>();
    mProductsPage = await locatorAPI.getProductsPageData();
    return mProductsPage;
  }

  Future readWinnersPage() async {
    final locatorAPI = GetIt.instance<ApiCalls>();
    mWinnersPage = await locatorAPI.getWinnersPageData();
    return mWinnersPage;
  }

  Future postQuestionAnswer(body) async {
    final locatorAPI = GetIt.instance<ApiCalls>();
    return await locatorAPI.postQuestionAnswer(body);
  }

  Future getQuizQuestion() async {
    final locatorAPI = GetIt.instance<ApiCalls>();
    return await locatorAPI.getQuizQuestion();
  }

  Future<void> readLangJson(lang) async {
    final String response = await rootBundle.loadString('assets/files/lang_${lang}.json');
    mLang = json.decode(response);
  }

  Future<void> saveLangPreference(lang) async {
    isUrdu = false;
    try{
      await prefs.setString('lang', lang);
      await readLangJson(lang);
      if(lang == 'ur'){
        isUrdu = true;
      }
      headers!['Accept-Language'] = lang;

      //await readProfilePage(mProfileDetailPage['userId']);

    }
    catch(e){
      print('saveLangPreference | ' + e.toString());
    }
  }

  Future getLang() async {
    isUrdu = false;
    try{
      final lang = prefs.getString('lang');
      //final lang = 'en';
      if(lang == null || lang.isEmpty){
        await saveLangPreference('en');
        return;
      }
      print(lang);
      await readLangJson(lang);
      if(lang == 'ur'){
        isUrdu = true;
      }
    }
    catch(e){
      print('getLang | ' + e.toString());
    }
  }

  Future<void> saveUserInfo(user) async {
    isUserLoggedIn = false;
    try{
      await prefs.setString('userData', json.encode(user));
      mProfileDetailPage = user;
      isUserLoggedIn = true;
      //await readProfilePage(mProfileDetailPage['userId']);

    }
    catch(e){
      print('saveUserInfo | ' + e.toString());
    }
  }

  Future getUserInfo() async {
    isUserLoggedIn = false;
    try{
      final user = prefs.getString('userData');
      print(user);
      if(user != null && user.isNotEmpty){
        mProfileDetailPage = json.decode(user);
        isUserLoggedIn = true;
        //await readProfilePage(mProfileDetailPage['userId']);
      }
    }
    catch(e){
      print('getUserInfo | ' + e.toString());
    }
  }

  Future logoutUser() async {
    await prefs.clear();
    isUserLoggedIn = false;
    isLanguageEmpty = true;
    mProfileDetailPage = {};
  }

  Future updateProfileData(data) async {
    mProfileDetailPage = data;
    await readProfilePage(mProfileDetailPage['userId']);
    await saveUserInfo(mProfileDetailPage);
  }

  Future addToCart(body) async {
    final locatorAPI = GetIt.instance<ApiCalls>();
    return await locatorAPI.addToCart(body);
  }

  Future addProductToCart(body) async {
    final locatorAPI = GetIt.instance<ApiCalls>();
    return await locatorAPI.addProductToCart(body);
  }

  Future removeFromCart(body) async {
    final locatorAPI = GetIt.instance<ApiCalls>();
    return await locatorAPI.removeFromCart(body);
  }

  isObscureActive(){
    isObscure = !isObscure;
  }

  showCustomSnackBar(message, BuildContext context){
    showTopSnackBar(
      Overlay.of(context)!,

      CustomSnackBar.success(
        message:
        message,
        icon: SizedBox(),
      ),
    );
  }

  showCustomSnackBarError(message, BuildContext context){
    showTopSnackBar(
      Overlay.of(context)!,

      CustomSnackBar.error(
        message:
        message,
        icon: SizedBox(),
      ),
    );
  }

  checkIfFirstLanding() async {
    final lang = prefs.getBool('isFirstLand');
    if(lang == null){
      await prefs.setBool('isFirstLand', false);
      isLanguageEmpty = true;
      return;
    }
  }
}