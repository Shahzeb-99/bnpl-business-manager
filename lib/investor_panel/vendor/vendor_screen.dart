import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/investor_panel/vendor/purchase_widget_vendor.dart';
import 'package:ecommerce_bnql/investor_panel/vendor/transaction_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../investor_panel/view_model/viewmodel_vendors.dart';
import '../view_model/viewmodel_user.dart';

List<PurchaseWidgetVendor> purchaseWidgetList = [];

class VendorProfile extends StatefulWidget {
  const VendorProfile({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  State<VendorProfile> createState() => _VendorProfileState();
}

class _VendorProfileState extends State<VendorProfile> {
  @override
  void initState() {
    updateProfile();
    super.initState();
  }

  TextEditingController moneyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late DateTime dateTime;
  late TimeOfDay time;
  TextStyle informationTextStyle = const TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Provider.of<VendorViewInvestor>(context, listen: false)
                    .allVendors[widget.index]
                    .name,
                style: const TextStyle(
                  fontSize: 25,
                  color: Color(0xFFE56E14),
                ),
              ),
              Provider.of<UserViewModel>(context, listen: false).readWrite
                  ? IconButton(
                      onPressed: () {
                        dateTime = DateTime.now();
                        time = TimeOfDay.now();
                        showModalBottomSheet<void>(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) {
                            return SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20))),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Center(
                                        child: Text(
                                          'Add Transaction',
                                          style: TextStyle(fontSize: 25),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: TextFormField(
                                          autofocus: true,
                                          controller: moneyController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp('[0-9-]'))
                                          ],
                                          decoration: kDecoration.inputBox(
                                              'Amount', 'PKR'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'This field is required';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: TextFormField(
                                          maxLines: 5,
                                          autofocus: true,
                                          controller: descriptionController,
                                          keyboardType: TextInputType.text,
                                          decoration: kDecoration.inputBox(
                                              'Description', ''),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please add a description for expense';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: InkWell(
                                          onTap: () async {
                                            DateTime? newDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: dateTime,
                                              initialDatePickerMode:
                                                  DatePickerMode.day,
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100),
                                            );
                                            setState(() {
                                              dateTime = newDate!;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              DateFormat.yMMMMEEEEd()
                                                  .format(dateTime),
                                              style: const TextStyle(
                                                  color: Color(0xFFE56E14),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            TimeOfDay? newTime =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now());
                                            setState(() {
                                              time = newTime!;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              DateFormat.jms().format(DateTime(
                                                  dateTime.year,
                                                  dateTime.month,
                                                  dateTime.day,
                                                  time.hour,
                                                  time.minute)),
                                              style: const TextStyle(
                                                  color: Color(0xFFE56E14),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            if (moneyController
                                                .text.isNotEmpty) {
                                              setState(() {});

                                              await Provider.of<
                                                          VendorViewInvestor>(
                                                      context,
                                                      listen: false)
                                                  .allVendors[widget.index]
                                                  .investorReference
                                                  .update({
                                                'currentBalance': FieldValue
                                                    .increment(int.parse(
                                                        moneyController.text))
                                              }).whenComplete(() {
                                                Provider.of<VendorViewInvestor>(
                                                        context,
                                                        listen: false)
                                                    .allVendors[widget.index]
                                                    .addTransaction(
                                                        amount: int.parse(
                                                            moneyController
                                                                .text),
                                                        description:
                                                            descriptionController
                                                                .text,
                                                        date: Timestamp
                                                            .fromDate(DateTime(
                                                                dateTime.year,
                                                                dateTime.month,
                                                                dateTime.day,
                                                                time.hour,
                                                                time.minute)));
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        'investorFinancials')
                                                    .doc('finance')
                                                    .update({
                                                  'cash_available': FieldValue
                                                      .increment(int.parse(
                                                          moneyController.text))
                                                });
                                              });
                                              moneyController.clear();
                                              descriptionController.clear();
                                              setState(() {
                                                Navigator.pop(context);
                                              });
                                            }
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                            Colors.grey.shade200,
                                          )),
                                          child: const Text('Add Expense'))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const FaIcon(FontAwesomeIcons.moneyCheckDollar),
                      splashRadius: 20,
                    )
                  : const SizedBox()
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text('Current Balance :', style: informationTextStyle),
                  Text(
                      ' ${Provider.of<VendorViewInvestor>(context, listen: false).allVendors[widget.index].currentBalance}',
                      style: TextStyle(
                          color: Provider.of<VendorViewInvestor>(context,
                                          listen: false)
                                      .allVendors[widget.index]
                                      .currentBalance <
                                  Provider.of<VendorViewInvestor>(context,
                                          listen: false)
                                      .allVendors[widget.index]
                                      .openingBalance
                              ? Colors.redAccent
                              : Colors.greenAccent,
                          fontSize: 20)),
                ],
              ),
              Text(
                  'Opening Balance : ${Provider.of<VendorViewInvestor>(context, listen: false).allVendors[widget.index].openingBalance}',
                  style: informationTextStyle),
              Row(
                children: [
                  Text('Outstanding Amount :', style: informationTextStyle),
                  Text(
                      ' ${Provider.of<VendorViewInvestor>(context, listen: false).allVendors[widget.index].outstandingBalance}',
                      style: TextStyle(
                          color: Provider.of<VendorViewInvestor>(context,
                                          listen: false)
                                      .allVendors[widget.index]
                                      .outstandingBalance >
                                  0
                              ? Colors.redAccent
                              : Colors.greenAccent,
                          fontSize: 20)),
                ],
              ),
              Row(
                children: [
                  Text('Amount Paid :', style: informationTextStyle),
                  Text(
                      ' ${Provider.of<VendorViewInvestor>(context, listen: false).allVendors[widget.index].amountPaid}',
                      style: TextStyle(
                          color: Provider.of<VendorViewInvestor>(context,
                                          listen: false)
                                      .allVendors[widget.index]
                                      .amountPaid >
                                  0
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontSize: 20)),
                ],
              ),
              Text(
                  'Company Profit : ${Provider.of<VendorViewInvestor>(context, listen: false).allVendors[widget.index].companyProfit}',
                  style: informationTextStyle),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                    Colors.grey.shade200,
                  )),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExpensesScreen(
                                  investorIndex: widget.index,
                                )));
                  },
                  child: const Text('Transaction History')),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  'All Products',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
                child: Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: purchaseWidgetList.isNotEmpty
                    ? ListView.builder(
                        physics: const ScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: purchaseWidgetList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return purchaseWidgetList[index];
                        })
                    : const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
              )
            ],
          ),
        ));
  }

  void updateProfile() async {
    purchaseWidgetList = [];

    final productCollection =
        await Provider.of<VendorViewInvestor>(context, listen: false)
            .allVendors[widget.index]
            .investorReference
            .collection('products')
            .get();
    for (QueryDocumentSnapshot productDocument in productCollection.docs) {
      makeWidget(productDocument);
    }
  }

  Future<void> makeWidget(QueryDocumentSnapshot productDocument) async {
    DocumentReference productReference =
        productDocument.get('productReference');
    DocumentSnapshot product = await productReference.get();
    final num outstandingAmount = product.get('outstanding_balance');
    final num amountPaid = product.get('paid_amount');
    productReference = product.get('product');
    product = await productReference.get();
    final String name = product.get('name');
    setState(() {
      purchaseWidgetList.add(PurchaseWidgetVendor(
        image:
            'https://media.istockphoto.com/vectors/thumbnail-image-vector-graphic-vector-id1147544807?k=20&m=1147544807&s=612x612&w=0&h=pBhz1dkwsCMq37Udtp9sfxbjaMl27JUapoyYpQm0anc=',
        name: name,
        outstandingBalance: outstandingAmount,
        amountPaid: amountPaid,
      ));
    });
  }
}

class kDecoration {
  static InputDecoration inputBox(String hintText, String suffix) {
    return InputDecoration(
      suffix: suffix.isNotEmpty ? const Text('PKR') : null,
      filled: true,
      fillColor: Colors.grey.shade200,
      hintStyle: const TextStyle(
        color: Color(0xFFE56E14),
      ),
      border: const OutlineInputBorder(),
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
