import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:six_pos/controller/cart_controller.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/data/model/response/account_model.dart';
import 'package:six_pos/data/model/response/transaction_model.dart';
import 'package:six_pos/data/model/response/transaction_type_model.dart';
import 'package:six_pos/data/repository/transaction_repo.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';

class TransactionController extends GetxController implements GetxService{
  final TransactionRepo transactionRepo;
  TransactionController({@required this.transactionRepo});
  bool _isLoading = false;
  bool _isFirst = true;
  bool get isFirst => _isFirst;
  bool get isLoading => _isLoading;
  int _transactionListLength;
  int get transactionListLength => _transactionListLength;
  List<Transfers> _transactionList = [];
  List<Transfers> get transactionList => _transactionList;

  List<Types> _transactionTypeList;
  List<Types> get transactionTypeList => _transactionTypeList;

  int _transactionTypeIndex = 0;
  int get transactionTypeIndex => _transactionTypeIndex;

  List<int> _transactionTypeIds = [];
  List<int> get transactionTypeIds => _transactionTypeIds;

  int _fromAccountIndex = 0;
  int get fromAccountIndex => _fromAccountIndex;
  int _toAccountIndex = 0;
  int get toAccountIndex => _toAccountIndex;

  int _selectedFromAccountId = 1;
  int get selectedFromAccountId => _selectedFromAccountId;
  int _selectedToAccountId = 0;
  int get selectedToAccountId => _selectedToAccountId;

  List<int> _fromAccountIds = [];
  List<int> get fromAccountIds => _fromAccountIds;

  List<int> _toAccountIds = [];
  List<int> get toAccountIds => _toAccountIds;

  List<Accounts> _accountList;
  List<Accounts> get accountList =>_accountList;


  String _transactionExportFilePath = '';
  String get transactionExportFilePath =>_transactionExportFilePath;






  Future<void> getTransactionList(int offset) async {
    _isLoading = true;
    Response response = await transactionRepo.getTransactionList(offset);
    if(response.statusCode == 200) {
      _transactionList.addAll(TransactionModel.fromJson(response.body).transfers);
      _transactionListLength = TransactionModel.fromJson(response.body).total;
      _isLoading = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<void> getCustomerWiseTransactionListList(int customerId ,int offset) async {
    _isLoading = true;
    Response response = await transactionRepo.getCustomerWiseTransactionList(customerId, offset);
    if(response.statusCode == 200) {
      _transactionList.addAll(TransactionModel.fromJson(response.body).transfers);
      _transactionListLength = TransactionModel.fromJson(response.body).total;
      _isLoading = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> getTransactionTypeList() async {
    _transactionTypeIndex = 0;
    _transactionTypeIds = [];
    _isLoading = true;
    Response response = await transactionRepo.getTransactionTypeList();
    if(response.statusCode == 200) {
      _transactionTypeList = [];
      _transactionTypeList.addAll(TransactionTypeModel.fromJson(response.body).types);
      if(_transactionTypeList.length != 0){
        for(int index = 0; index < _transactionTypeList.length; index++) {
          _transactionTypeIds.add(_transactionTypeList[index].id);
        }
        _transactionTypeIndex = _transactionTypeIds[0];
      }

      _isLoading = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getTransactionFilter(String startDate, String endDate, int accountId, String accountType) async {
    _transactionList = [];
    _isLoading = true;
    Response response = await transactionRepo.getTransactionFilter(startDate, endDate, accountId, accountType);
    if(response.statusCode == 200) {
      _transactionList = [];
      _transactionList.addAll(TransactionModel.fromJson(response.body).transfers);
      _transactionListLength = TransactionModel.fromJson(response.body).total;
      _isLoading = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<void> addTransaction(Transfers transfer, int fromAccountId, int toAccountId) async {
    _isLoading = true;
    Response response = await transactionRepo.addNewTransaction(transfer, fromAccountId, toAccountId);
    if(response.statusCode == 200) {
      getTransactionList(1);
      Get.back();
      showCustomSnackBar('transaction_added_successfully'.tr,  isError: false);
      _isLoading = false;
    }else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }


  Future<void> getTransactionAccountList( int offset) async {
    _fromAccountIndex = 0;
    _toAccountIndex = 0;
    _fromAccountIds = [];
    _toAccountIds = [];
    _isLoading = true;
    Response response = await transactionRepo.getTransactionAccountList(offset);
    if(response.statusCode == 200) {
      _accountList = [];
      _accountList.addAll(AccountModel.fromJson(response.body).accounts);
      if(_accountList.length != 0){
        for(int index = 0; index < _accountList.length; index++) {
          _fromAccountIds.add(_accountList[index].id);
        }
        _fromAccountIndex = _fromAccountIds[0];
      }
      if(_accountList.length > 1){
        for(int index = 0; index < _accountList.length; index++) {
          _toAccountIds.add(_accountList[index].id);
        }
        _toAccountIndex = _toAccountIds[0];
      }

      _isLoading = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  void addCustomerBalanceIntoAccountList(Accounts accounts) {
    print('==============koybar===========${Get.find<CartController>().customerId}');
    _fromAccountIndex = 0;
    _fromAccountIds = [];
    if ((_accountList.any((e) => e.id == accounts.id && Get.find<CartController>().customerId == 0)) ) {
      if(accounts.id == 0){
        _accountList.removeAt(_accountList.length-1);
        for(int index = 0; index < _accountList.length; index++) {
          _fromAccountIds.add(_accountList[index].id);
        }
        _fromAccountIndex = _fromAccountIds[0];
      }

      else if(_accountList.length != 0){
        for(int index = 0; index < _accountList.length; index++) {
          _fromAccountIds.add(_accountList[index].id);
        }
        _fromAccountIndex = _fromAccountIds[0];
      }
    }else if ((_accountList.any((e) => e.id != accounts.id && Get.find<CartController>().customerId == 0)) ) {
        for(int index = 0; index < _accountList.length; index++) {
          _fromAccountIds.add(_accountList[index].id);
        }
        _fromAccountIndex = _fromAccountIds[0];

    }
    else if ((_accountList.any((e) => e.id == accounts.id &&  Get.find<CartController>().customerId != 0)) ) {
        for(int index = 0; index < _accountList.length; index++) {
          _fromAccountIds.add(_accountList[index].id);
        }
        _fromAccountIndex = _fromAccountIds[0];

    }else if (_accountList.any((e) => e.id != accounts.id) && Get.find<CartController>().customerId == 0) {
      for(int index = 0; index < _accountList.length; index++) {
        _fromAccountIds.add(_accountList[index].id);
      }
      _fromAccountIndex = _fromAccountIds[0];
    }
    else{
      _accountList.add(accounts);
      if(_accountList.length != 0){
        for(int index = 0; index < _accountList.length; index++) {
          _fromAccountIds.add(_accountList[index].id);
        }
        _fromAccountIndex = _fromAccountIds[0];
      }
    }

    update();
  }


  Future<void> exportTransactionList(String startDate, String endDate, int accountId, String transactionType) async {
    _isLoading = true;
    Response response = await transactionRepo.exportTransactionList(startDate, endDate, accountId, transactionType);
    if(response.statusCode == 200) {
      Map map = response.body;
      _transactionExportFilePath = map['excel_report'];
      _isLoading = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }



  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void removeFirstLoading() {
    _isFirst = true;
    update();
  }

  void setAccountIndex(int index, String type , bool notify) {
    if(type == 'from'){
      _fromAccountIndex = index;
      _selectedFromAccountId = _fromAccountIndex;
      print('dd==============>$_selectedFromAccountId');
    }else{
      _toAccountIndex = index;
      _selectedToAccountId = _toAccountIndex;
    }

    if(notify) {
      update();
    }
  }

  void setTransactionTypeIndex(int index , bool notify) {
    _transactionTypeIndex = index;
    print('=====TT=====>$_transactionTypeIndex');
    if(notify) {
      update();
    }
  }


  DateTime _startDate;
  DateTime _endDate;
  DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  DateFormat get dateFormat => _dateFormat;

  void selectDate(String type, BuildContext context){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    ).then((date) {
      if (type == 'start'){
        _startDate = date;
      }else{
        _endDate = date;
      }
      if(date == null){
        print('Null');
      }
      update();
    });
  }



}