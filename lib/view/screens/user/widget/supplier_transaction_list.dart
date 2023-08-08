import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/supplier_controller.dart';
import 'package:six_pos/data/model/response/supplier_model.dart';
import 'package:six_pos/data/model/response/transaction_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/view/base/no_data_screen.dart';
import 'package:six_pos/view/screens/account_management/widget/transaction_list_card_widget.dart';


class SupplierTransactionListView extends StatelessWidget {
  final Suppliers supplier;
  final ScrollController scrollController;
  const SupplierTransactionListView({Key key, this.scrollController, this.supplier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<SupplierController>().supplierTransactionList.length != 0
          && !Get.find<SupplierController>().isLoading) {
        int pageSize;
        pageSize = Get.find<SupplierController>().supplierTransactionListLength;

        if(offset < pageSize) {
          offset++;
          print('end of the page');
          Get.find<SupplierController>().showBottomLoader();
          Get.find<SupplierController>().getSupplierTransactionList(offset, supplier.id);
        }
      }

    });

    return GetBuilder<SupplierController>(
      builder: (supplierController) {
        List<Transfers> transactionList;
        transactionList = supplierController.supplierTransactionList;

        return Column(children: [
          !supplierController.isFirst ? transactionList != null ? transactionList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: transactionList.length,
              physics:  BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return TransactionCardViewWidget(transfer: transactionList[index], index: index);

              }): NoDataScreen() : SizedBox.shrink():SizedBox(),
          supplierController.isLoading ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}
