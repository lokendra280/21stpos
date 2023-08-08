
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/supplier_controller.dart';
import 'package:six_pos/data/model/response/supplier_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/view/base/account_shimmer.dart';
import 'package:six_pos/view/base/no_data_screen.dart';
import 'package:six_pos/view/screens/user/widget/supplier_card_view_widget.dart';

class SupplierListView extends StatelessWidget {
  final ScrollController scrollController;
  const SupplierListView({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<SupplierController>().supplierList.length != 0
          && !Get.find<SupplierController>().isGetting) {
        int pageSize;
        pageSize = Get.find<SupplierController>().supplierListLength;

        if(offset < pageSize) {
          offset++;
          print('end of the page');
          Get.find<SupplierController>().showBottomLoader();
          Get.find<SupplierController>().getSupplierList(offset);
        }
      }

    });

    return GetBuilder<SupplierController>(
      builder: (supplierController) {
        List<Suppliers> supplierList;
        supplierList = supplierController.supplierList;

        return Column(children: [

          !supplierController.isFirst ? supplierList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: supplierList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return SupplierCardViewWidget(supplier: supplierList[index]);

              }) : AccountShimmer() : NoDataScreen(),
          supplierController.isLoading ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}
