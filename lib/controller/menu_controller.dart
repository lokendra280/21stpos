import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/view/screens/home/home_screens.dart';
import 'package:six_pos/view/screens/pos/pos_screen.dart';
import 'package:six_pos/view/screens/product/limited_product_screen.dart';
import 'package:six_pos/view/screens/product/product_list_with_category.dart';

class MenuController extends GetxController implements GetxService{
  int _currentTab = 0;
  int get currentTab => _currentTab;
  final List<Widget> screen = [
    HomeScreen(),
    PosScreen(),
    ItemsScreen(),
    LimitedStockProductScreen()
  ];
  Widget _currentScreen = HomeScreen();
  Widget get currentScreen => _currentScreen;

  resetNavBar(){
    _currentScreen = HomeScreen();
    _currentTab = 0;
  }

  selectHomePage() {
    _currentScreen = HomeScreen();
    _currentTab = 0;
     update();
  }

  selectPosScreen() {
    _currentScreen = PosScreen();
    _currentTab = 1;
    update();
  }

  selectItemsScreen() {
    _currentScreen = ItemsScreen();
    _currentTab = 2;
    update();
  }

  selectStockOutProductList() {
    _currentScreen = LimitedStockProductScreen();
    _currentTab = 3;
    update();
  }
}
