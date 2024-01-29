import 'package:enaam/common/service_locator.dart';
import 'package:enaam/popups/enaamLang.dart';
import 'package:enaam/screens/cart.dart';
import 'package:enaam/screens/draws.dart';
import 'package:enaam/screens/home.dart';
import 'package:enaam/screens/notifications.dart';
import 'package:enaam/screens/tickets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';

import '../common/enaam_json_parser.dart';

class EnaamBottomNavScreen extends StatefulWidget {
  const EnaamBottomNavScreen({Key? key}) : super(key: key);

  @override
  _EnaamBottomNavScreenState createState() => _EnaamBottomNavScreenState();
}

class _EnaamBottomNavScreenState extends State<EnaamBottomNavScreen> {
  final locator = GetIt.instance<EnaamJsonParser>();
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    NotificationScreen(),
    DrawsScreen(),
    TicketsScreen(),
    CartScreen()
  ];

  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale(!locator.isUrdu ? 'en' : 'ur'),
      supportedLocales: const [
        Locale('en'),
        Locale('ur'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: Directionality(
        textDirection: locator.isUrdu ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          bottomNavigationBar: !locator.isLanguageEmpty ? BottomNavigationBar(
              currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/images/home.png"),
                ),
                //label: 'Home',
                label: locator.mLang['home'],
                activeIcon: ImageIcon(
                  AssetImage("assets/images/home_active.png",),
                ),
              ),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage("assets/images/notification.png"),
                  ),
                  //label: 'Notifications',
                label: locator.mLang['notifications'],
                activeIcon: ImageIcon(
                  AssetImage("assets/images/notification_active.png",),
                ),
              ),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage("assets/images/draw.png"),
                  ),
                  //label: 'Draws',
                label: locator.mLang['draws'],
                activeIcon: ImageIcon(
                  AssetImage("assets/images/draws_active.png",),
                ),
              ),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage("assets/images/ticket.png"),
                  ),
                  //label: 'Tickets',
                label: locator.mLang['tickets'],
                activeIcon: ImageIcon(
                  AssetImage("assets/images/ticket_active.png",),
                ),
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/images/cart.png"),
                ),
                //label: 'Cart',
                label: locator.mLang['cart'],
                activeIcon: ImageIcon(
                  AssetImage("assets/images/cart_active.png",),
                ),
              ),
            ],
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color(0xffDA4430),
            unselectedItemColor: Color(0xff272D4E),
            elevation: 5,
            showUnselectedLabels: true,
            selectedFontSize: 12,
            unselectedFontSize: 12,
          ) : null,
          body: !locator.isLanguageEmpty ? Center(child: _widgetOptions.elementAt(_selectedIndex)) : EnaamLangPopup()
      ),)
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
