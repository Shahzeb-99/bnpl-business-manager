import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_bnql/company_panel/model/customers.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import '../../investor_panel/view_model/viewmodel_user.dart';
import '../view_model/viewmodel_customers.dart';
import 'add_new_customer/add_customer_screen.dart';
import 'customer_page/customer_screen.dart';
import 'package:intl/intl.dart';

enum CustomerFilterOptions { all, oneMonth, sixMonths }

class AllCustomersScreen extends StatefulWidget {
  const AllCustomersScreen({Key? key}) : super(key: key);

  @override
  State<AllCustomersScreen> createState() => _AllCustomersScreenState();
}

class _AllCustomersScreenState extends State<AllCustomersScreen> {
  @override
  void initState() {
    if (Provider.of<CustomerView>(context, listen: false).option == CustomerFilterOptions.all) {
      Provider.of<CustomerView>(context, listen: false).getCustomers();
    } else {
      //Provider.of<CustomerView>(context, listen: false).getThisMonthCustomers();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Customers',
              style: TextStyle(
                fontSize: 25,
                color: Color(0xFFE56E14),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: CustomSearchDelegate());
                },
                icon: const Icon(Icons.search)),
            IconButton(
                onPressed: () async {
                  int topLimit = 0;
                  int bottomLimit = -10;
                  final pdf = pw.Document();
                  final finance = await FirebaseFirestore.instance.collection('financials').doc('finance').get();
                  final outstanding = finance.get('outstanding_balance');
                  final amountPaid = finance.get('amount_paid');
                  final image = (await rootBundle.load('assets/dart.png')).buffer.asUint8List();
                  final list = Provider.of<CustomerView>(context, listen: false).thisMonthCustomer;
                  for (var v = 0; v < list.length; v = v + 10) {




                    pdf.addPage(
                      pw.Page(
                          build: (pw.Context context) => pw.Column(
                                children: [
                                  pw.SizedBox(
                                      width: 250,
                                      child: pw.Center(
                                        child: pw.Image(pw.MemoryImage(image)),
                                      )),
                                  pw.SizedBox(height: 25),
                                  pw.Center(
                                    child: pw.Text(
                                      'Customers List',
                                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                    ),
                                  ),
                                  pw.SizedBox(height: 100),
                                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
                                    pw.Row(children: [
                                      pw.Expanded(
                                          child: pw.Text(
                                        'Name',
                                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                      )),
                                      pw.Expanded(
                                          child: pw.Text(
                                        'Outstanding Balance',
                                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                      )),
                                      pw.Expanded(
                                          child: pw.Text(
                                        'Amount Paid',
                                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                      )),
                                    ]),
                                    pw.Divider(thickness: 1, color: PdfColors.black)
                                  ]),
                                  pw.ListView.builder(
                                      itemBuilder: (pw.Context context, int index) {

                                        if (index==0) {
                                          bottomLimit+=10;
                                          topLimit+=10;
                                        }
                                        if (index<topLimit&&index>=bottomLimit) {

                                          return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
                                            pw.Row(children: [
                                              pw.Expanded(
                                                  child: pw.Text(
                                                list[index].name,
                                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                              )),
                                              pw.Expanded(
                                                  child: pw.Text(
                                                '${list[index].outstandingBalance}',
                                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                              )),
                                              pw.Expanded(
                                                  child: pw.Text(
                                                '${list[index].paidAmount}',
                                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                              )),
                                            ]),
                                            pw.Divider(color: PdfColors.black)
                                          ]);
                                        }else{return pw.SizedBox();}
                                      },
                                      itemCount: list.length),
                                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
                                    pw.Row(children: [
                                      pw.Expanded(child: pw.Text('')),
                                      pw.Expanded(
                                          child: pw.Text(
                                        'Total Outstanding',
                                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                      )),
                                      pw.Expanded(
                                          child: pw.Text(
                                        outstanding.toString(),
                                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                      )),
                                    ]),
                                    pw.Divider(thickness: 1, color: PdfColors.black)
                                  ]),
                                  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
                                    pw.Row(children: [
                                      pw.Expanded(child: pw.Text('')),
                                      pw.Expanded(
                                          child: pw.Text(
                                        'Total Amount Paid',
                                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                      )),
                                      pw.Expanded(
                                          child: pw.Text(
                                        amountPaid.toString(),
                                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                      )),
                                    ]),
                                    pw.Divider(thickness: 1, color: PdfColors.black)
                                  ]),
                                  pw.Expanded(child: pw.Container()),
                                  pw.Footer(
                                    title: pw.Text(
                                      "Generated on : ${DateFormat.yMMMMd().add_jm().format(DateTime.now())}",
                                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                    ),
                                  )
                                ],
                              )),
                    );
                  }
                  final path = (await getApplicationDocumentsDirectory()).path;
                  final file = File('${path}exameple.pdf');
                  await file.writeAsBytes(await pdf.save()).whenComplete(() async => await OpenFilex.open(file.path));
                },
                icon: const Icon(Icons.picture_as_pdf_rounded)),
            Provider.of<UserViewModel>(context, listen: false).readWrite
                ? IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddCustomerScreen()));
                    },
                    icon: const Icon(Icons.add_rounded),
                    splashRadius: 25,
                  )
                : const SizedBox()
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: ListView.builder(
            physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: Provider.of<CustomerView>(context, listen: false).option == CustomerFilterOptions.all
                ? Provider.of<CustomerView>(context).thisMonthCustomer.length
                : Provider.of<CustomerView>(context).thisMonthCustomers.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    side: BorderSide(
                      width: 1,
                      color: Color(0xFFEEAC7C),
                    )),
                elevation: 2,
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerProfile(index: index)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(Provider.of<CustomerView>(context, listen: false).option == CustomerFilterOptions.all
                              ? Provider.of<CustomerView>(context).thisMonthCustomer[index].image
                              : Provider.of<CustomerView>(context).thisMonthCustomers[index].image),
                          radius: 30,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Provider.of<CustomerView>(context, listen: false).option == CustomerFilterOptions.all
                                  ? Provider.of<CustomerView>(context).thisMonthCustomer[index].name
                                  : Provider.of<CustomerView>(context).thisMonthCustomers[index].name,
                              style: kBoldText,
                            ),
                            Text(
                              'Outstanding Balance : ${Provider.of<CustomerView>(context, listen: false).option == CustomerFilterOptions.all ? Provider.of<CustomerView>(context).thisMonthCustomer[index].outstandingBalance : Provider.of<CustomerView>(context).thisMonthCustomers[index].outstandingBalance} PKR',
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

const TextStyle kBoldText = TextStyle(fontWeight: FontWeight.bold);

class CustomSearchDelegate extends SearchDelegate {
// Demo list to show querying

// first overwrite to
// clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<Customers> matchQuery = [];
    for (var fruit in Provider.of<CustomerView>(context).thisMonthCustomer) {
      if (fruit.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              side: BorderSide(
                width: 1,
                color: Color(0xFFEEAC7C),
              )),
          elevation: 2,
          color: Colors.white,
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerProfile(index: matchQuery[index].index)));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(result.image),
                    radius: 30,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.name,
                        style: kBoldText,
                      ),
                      Text(
                        'Outstanding Balance : ${result.outstandingBalance} PKR',
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// last overwrite to show the
// querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<Customers> matchQuery = [];
    for (var fruit in Provider.of<CustomerView>(context).thisMonthCustomer) {
      if (fruit.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              side: BorderSide(
                width: 1,
                color: Color(0xFFEEAC7C),
              )),
          elevation: 2,
          color: Colors.white,
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerProfile(index:  matchQuery[index].index)));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(result.image),
                    radius: 30,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.name,
                        style: kBoldText,
                      ),
                      Text(
                        'Outstanding Balance : ${result.outstandingBalance} PKR',
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
