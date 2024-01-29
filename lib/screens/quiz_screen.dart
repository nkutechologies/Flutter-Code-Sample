import 'package:enaam/model/question_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hexcolor/hexcolor.dart';

import '../common/enaam_json_parser.dart';
import 'enaam_webview.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final locator = GetIt.instance<EnaamJsonParser>();

  int _currentQuestionIndex = 0;
  final List<Question> _questions = questions;
  List<String> _selectedAnswers = [];
  bool _canConfirm = false;
  bool _showPopup = true;
  bool isDontShow = false;
  bool isDialogueRender = false;
  var _isApiCalled = true;
  var _isAnswerApiCalled = false;

  var selectedIndex = -1;

  var question = {};
  void _onAnswerSelected(String answer) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answer;
      _canConfirm = true;
    });
  }

  void _onConfirm() {
    if (!_canConfirm) return;

    String correctAnswer = _questions[_currentQuestionIndex].correctAnswer;
    if (_selectedAnswers[_currentQuestionIndex] == correctAnswer) {
      // Increment the user's score
    }
    if (_currentQuestionIndex == _questions.length - 1) {
      //  Navigate to the results screen
      print("Navigate to the results screen");
    } else {
      setState(() {
        _currentQuestionIndex++;
        _canConfirm = false;
      });
    }
  }

  @override
  void initState() {
    _getQuestion();
    super.initState();
    _selectedAnswers = List.generate(_questions.length, (_) => '');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: !_isApiCalled ? Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg_gradient.png"),
                fit: BoxFit.fill
            )
            ,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: const [
                        Icon(
                          Icons.arrow_back_sharp,
                          size: 27,
                        ),
                      ],
                    ),
                  ),
                  // if (_showPopup) _buildPopup(),
                  // IconButton(
                  //     onPressed: () {}, icon: Icon(Icons.arrow_back_rounded)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 160,
                        width: 370,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/question_background.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            question['title'].toString(),//_questions[_currentQuestionIndex].questionText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w900),
                          ),
                        )),
                  ),

                  /*Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 200,
                      width: 379,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/question_image.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),*/

                  const SizedBox(height: 32.0),
                  _buildAnswerOptions(),
                  // ElevatedButton(
                  //   onPressed: _onConfirm,
                  //   child: Text('Confirm'),
                  // ),
                  Spacer(),
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
                          if(!_isAnswerApiCalled && selectedIndex != -1){
                            _submitAnswer(size);
                          }

                          //_onConfirm();
                        },
                        child: !_isAnswerApiCalled ? Text(
                          //'CONFIRM',
                          locator.mLang['confirm'],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ) : SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
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
        ),
      ),
    );
  }

  Widget _buildAnswerOptions() {
    final options = question['options']; //_questions[_currentQuestionIndex].answerOptions;

    return GridView.builder(
      shrinkWrap: true,
      itemCount: options.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
              /*_selectedAnswers[_currentQuestionIndex] = options[index];
              _canConfirm = true;*/
            });
          },
          child: Card(
            color: selectedIndex == index
                ? Colors.green
                : HexColor("#26A6DF"),
            child: Center(
              child: Text(
                options[index]['optionTitle'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _getQuestion() async {
    final response =  await locator.getQuizQuestion();
    if(response != null){
      final status = response['status'];
      if(status == 'Success'){
        question = response['data'];
        setState(() {
          _isApiCalled = false;
        });
      }
    }

  }

  Future<void> _submitAnswer(Size size) async {
    setState(() {
      _isAnswerApiCalled = true;
    });

    final questionId = question['id'];
    final userId = locator.mProfileDetailPage['userId'];
    final optionId = question['options'][selectedIndex]['id'];


    final Map<String, dynamic> body = {
      "questionId": questionId,
      "userId": userId,
      "optionId": optionId,
    };


    final response = await locator.postQuestionAnswer(body);
    if(response != null){
      final status = response['status'];
      if(status == 'Success'){
        final data = response['data'];
        _checkout(size,data);
      }
    }

    print(response);

    /*Navigator.pop(context);
    Navigator.pop(context);*/
  }

  void _checkout(Size size, data) {
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
                  _processPayment('MWALLET',data);
                }

              },
              child: Row(
                children: [
                  Container(
                    width: size.width * 0.15,
                    height: size.width * 0.15,
                    margin: EdgeInsetsDirectional.only(start: 20),
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
                  _processPayment('MPAY',data);
                }

              },
              child: Row(
                children: [
                  Container(
                    width: size.width * 0.15,
                    height: size.width * 0.15,
                    margin: EdgeInsetsDirectional.only(start: 20),
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

  Future<void> _processPayment(String type, data) async {
    setState(() {
      _isApiCalled = true;
    });

    final userId = locator.mProfileDetailPage['userId'];
    final products = locator.mCartPage['data']['products'];
    final amount = locator.mCartPage['data']['total'];

    final Map<String, dynamic> productsData = {

    };

    for(int i=0; i < products.length; i++){
      productsData[products[i]['productId'].toString()] = products[i]['quantity'];
    }

    final Map<String, dynamic> body = {
      "txnType": type,
      "userId": userId,
      "amount": amount,
      "products": productsData,
      "answer": data.toString(),
    };

    print(body);
    final response = await locator.processPayment(body);

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
}
