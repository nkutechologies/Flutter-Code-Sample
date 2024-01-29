import 'package:enaam/common/service_locator.dart';
import 'package:enaam/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../common/enaam_json_parser.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  bool isDontShow = false;
  final locator = GetIt.instance<EnaamJsonParser>();

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsetsDirectional.only(start: 10),
                child: Icon(
                  Icons.arrow_back_sharp,
                  size: 27,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                      child: Text(
                    //'HOW TO PLAY',
                    locator.mLang['how_to_play'],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        //'1. Answer the question on the next screen',
                        locator.mLang['atqotns'] ,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                          //'2. Your answer applies to all tickets in this competition order',
                          locator.mLang['yaatat'] ,
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text(
                          //'3. Competition ends at midnight Wednesday 12th April',
                          locator.mLang['ceam'] ,
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text(
                          //'4. Winner independently selected at random from all correct entries by PromoVeritas, and announced on Thursday 13th April',
                          locator.mLang['wisa'] ,
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: isDontShow,
                            onChanged: (value) {
                              setState(() {
                                isDontShow = value!;
                              });
                            },
                          ),
                          Text(
                              //'Don\'t show this again'
                              locator.mLang['dont_show_this_again']
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: size.width,
                          height: size.height * 0.06,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QuizScreen()),
                                );
                              },
                              child: Text(
                                //'NEXT',
                                locator.mLang['next'],
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
