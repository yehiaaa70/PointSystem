import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:test_project/UI/sales/sales/sales.dart';
import 'package:test_project/UI/widgets/bottom_item.dart';
import 'package:test_project/UI/widgets/end_drawer_home.dart';
import 'customers/customers.dart';
import 'monthly/Monthly.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;
  final GlobalKey _bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();

  List screens = [const CustomersScreen(), const SalesScreen(),  Monthly()];

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Widget showLoadingIndicator() => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      );
  BuildContext? contextDialog;

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus.toString() == "ConnectivityResult.wifi" ||
        _connectionStatus.toString() == "ConnectivityResult.mobile") {
      return Scaffold(
        key: _scaffoldKey,
        body: screens[_currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          animationCurve: Curves.fastOutSlowIn,
          index: 1,
          height: 70,
          key: _bottomNavigationKey,
          color: Colors.black45,
          buttonBackgroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          items: <Widget>[
            bottomItem("assets/images/shopping.png"),
            bottomItem("assets/images/home.png"),
            bottomItem("assets/images/calendar.png"),
          ],
          onTap: (index) {
            setState(() {
              if(index == 3) {
                _scaffoldKey.currentState!.openEndDrawer();
              }
              else {
                _currentIndex = index;
              }
            });
          },
        ),
      );
    } else {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(child: Lottie.asset("assets/images/nodata.json")),
        ),
      );
    }
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }
}
