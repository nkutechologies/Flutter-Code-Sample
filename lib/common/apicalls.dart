import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'enaam_json_parser.dart';
import 'endpoints.dart' as EndPoints;

class ApiCalls{
  final locatorAPI = GetIt.instance<EnaamJsonParser>();

  Future login(body) async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.SIGNIN}');

      var response = await client.post(uri,body: jsonEncode(body),headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future processPayment(body) async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.PAYMENT}');

      var response = await client.post(uri,body: jsonEncode(body),headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future changePassord(body) async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.CHANGE_PASSWORD}');

      var response = await client.post(uri,body: jsonEncode(body),headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future updateProfilePicture(PickedFile file,userId) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://enaam.pk/api/users/updateProfilePicture/${userId}'),);


    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath("profileImage", file.path));

    var response =await request.send();

    //for getting and decoding the response into json format
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);
    return responseData;

    //print(responseData);





/*    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.UPDATE_PROFILE_PIC}/${userId}');

      var response = await client.post(uri,body: jsonEncode(body),headers: {"Content-Type": "application/json"});
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;*/
  }

  Future getQuizQuestion() async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.QUIZ_QUESTION}');

      var response = await client.get(uri, headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future getHomePageData() async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.HOME_PAGE}');

      var response = await client.get(uri, headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future getNotificationPageData() async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.NOTIFICATIONS}');

      var response = await client.get(uri, headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future getDrawsPageData() async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.DRAWS}');

      var response = await client.get(uri, headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future getProductsPageData() async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.PRODUCTS}');

      var response = await client.get(uri, headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future getWinnersPageData() async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.WINNERS}');

      var response = await client.get(uri, headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future getTicketsPageData(userId) async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.TICKETS}${userId}');

      var response = await client.get(uri, headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future generateOTP(userId) async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.GENERATE_OTP}${userId}');

      var response = await client.post(uri, headers: locatorAPI.headers);
      final result = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      return result;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future verifyOTP(userId,otp) async {
    var client = http.Client();

    final Map<String, String> body = {
      "otp": otp,
    };

    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.VERIFY_OTP}${userId}');

      var response = await client.put(uri, body: jsonEncode(body), headers: locatorAPI.headers);
      final result = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      return result;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future getProfileData(userId) async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.PROFILE_PAGE}${userId}');

      var response = await client.get(uri, headers: locatorAPI.headers);
      final result = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      return result;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future getCartData(userId) async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.GET_CART}${userId}');

      var response = await client.get(uri, headers: locatorAPI.headers);
      final result = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final locator = GetIt.instance<EnaamJsonParser>();
      locator.mCartPage = result;
      return result;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future getProfileDetailsData(userId) async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.PROFILE_DETAIL_PAGE}${userId}');

      var response = await client.get(uri, headers: locatorAPI.headers);
      final result = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      return result;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future forgotPass(body) async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.FORGOT_PASS}');

      var response = await client.post(uri,body: jsonEncode(body),headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future postQuestionAnswer(body) async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.QUESTION_ANSWER}');

      var response = await client.post(uri,body: jsonEncode(body),headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future forgotPassUpdate(body) async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.FORGOT_PASS_UPDATE}');

      var response = await client.post(uri,body: jsonEncode(body),headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future register(body) async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.SIGNUP}');

      var response = await client.post(uri,body: jsonEncode(body),headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future updateProfile(body) async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.UPDATE_PROFILE}');

      var response = await client.post(uri,body: jsonEncode(body),headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future addToCart(body) async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.ADDTOCART}');

      var response = await client.post(uri,body: jsonEncode(body),headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future addProductToCart(body) async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.ADDPRODUCTTOCART}');

      var response = await client.post(uri,body: jsonEncode(body),headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }

  Future removeFromCart(body) async {
    var client = http.Client();
    try {
      final uri = Uri.https('${EndPoints.BASE_URL}',
          '${EndPoints.REMOVEFROMCART}');

      var response = await client.delete(uri,body: jsonEncode(body),headers: locatorAPI.headers);
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    return null;
  }


}