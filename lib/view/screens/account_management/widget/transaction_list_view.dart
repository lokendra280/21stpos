
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/transaction_controller.dart';
import 'package:six_pos/data/model/response/transaction_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/view/base/account_shimmer.dart';
import 'package:six_pos/view/base/no_data_screen.dart';
import 'package:six_pos/view/screens/account_management/widget/transaction_list_card_widget.dart';



class TransactionListView extends StatelessWidget {
  final bool isHome;
  final ScrollController scrollController;
  const TransactionListView({Key key, this.scrollController, this.isHome = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<TransactionController>().transactionList.length != 0
          && !Get.find<TransactionController>().isLoading) {
        int pageSize;
        pageSize = Get.find<TransactionController>().transactionListLength;

        if(offset < pageSize  && !isHome) {
          offset++;
          print('end of the page');
          Get.find<TransactionController>().showBottomLoader();
          Get.find<TransactionController>().getTransactionList(offset);
        }
      }

    });

    return GetBuilder<TransactionController>(
      builder: (transactionController) {
        List<Transfers> transactionList;
        transactionList = transactionController.transactionList;

        return Column(children: [
          !transactionController.isFirst ? transactionList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: isHome && transactionList.length> 3 ? 3: transactionList.length,
              physics: isHome? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return TransactionCardViewWidget(transfer: transactionList[index], index: index);

              }): NoDataScreen() : AccountShimmer(),
          transactionController.isLoading ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}
