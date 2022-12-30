import 'dart:io';
import 'package:ecommerce_bnql/investor_panel/customer/payment_schedule_class.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart'  ;

import '../investor_panel/model/purchases.dart';

class CustomRow {
  final String itemName;
  final String itemPrice;
  final String amount;
  final String total;

  CustomRow(this.itemName, this.itemPrice, this.amount, this.total);
}

class PdfInvoiceServiceInvestor {


  Future<Uint8List> createInvoice(Purchase soldProducts) async {
    final pdf = pw.Document();
//final  investorRef= await soldProducts.investorReference.get();
final investorName  = 'investorRef.get(''name'')';

    final List<CustomRow> elements = [
      CustomRow(
        "Item Name",
        "Selling Amount ",
        "Purchase Amount",
        "Total Profit",
      ),
      CustomRow(
        soldProducts.productName,
        soldProducts.sellingAmount.toString(),
        soldProducts.purchaseAmount.toString(),
        (soldProducts.sellingAmount - soldProducts.purchaseAmount).toString(),
      ),
    ];
    final image =
    (await rootBundle.load("assets/dart.png")).buffer.asUint8List();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Image(pw.MemoryImage(image),
                  width: 200, height: 101, fit: pw.BoxFit.fill),
              pw.SizedBox(height: 50),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Customer Name : ${soldProducts.customerName}",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                      pw.Text("Investor Name : $investorName",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),

                      pw.Text(
                        "Purchase Date: ${DateFormat.yMMMMd().format(soldProducts.purchaseDate.toDate())}",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),

                      ),

                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 50),
              itemColumn(elements),
              pw.Row(children: [
                pw.Expanded(
                    child: pw.Column(children: [
                      pw.SizedBox(width: 200, child: pw.Divider()),
                      pw.Text('Investor Signature',style: pw.TextStyle(fontWeight: pw.FontWeight.bold),)
                    ])),
                pw.Expanded(child: pw.Container()),
                pw.Expanded(
                    child: pw.Column(children: [
                      pw.SizedBox(width: 200, child: pw.Divider()),
                      pw.Text('Company Signature',style: pw.TextStyle(fontWeight: pw.FontWeight.bold),)
                    ])),
              ]),
              pw.SizedBox(height: 25),
              pw.Text("Thanks for your trust, and till the next time.",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
              pw.SizedBox(height: 25),
              pw.Text("Kind regards,",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
              pw.SizedBox(height: 25),
              pw.Text("Friends Traders",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),)
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  Future<Uint8List> createPaymentList(
      List<PaymentSchedule> paymentSchedule, Purchase soldProduct) async {
    final pdf = pw.Document();

    final image =
    (await rootBundle.load("assets/dart.png")).buffer.asUint8List();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Image(pw.MemoryImage(image),
                  width: 200, height: 101, fit: pw.BoxFit.fill),
              pw.SizedBox(height: 50),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Customer Name : ${soldProduct.customerName}",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                      pw.Text(
                        "Product Name : ${soldProduct.productName}",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),

                      ),
                      pw.Text(
                        "Purchase Date: ${DateFormat.yMMMMd().format(soldProduct.purchaseDate.toDate())}",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),

                      ),

                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 50),
              pw.Column(children: [
                pw.Row(
                  children: [
                    pw.Expanded(
                        child: pw.Text("Date", textAlign: pw.TextAlign.left ,style: pw.TextStyle(fontWeight: pw.FontWeight.bold),)),
                    pw.Expanded(
                        child:
                        pw.Text("Amount ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
                    pw.Expanded(
                        child: pw.Text("Remaining Amount",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.right)),
                    pw.Expanded(
                        child: pw.Text("Payment Status",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.right)),
                  ],
                ),
                pw.Divider()
              ]),
              paymentScheduleColumn(paymentSchedule, soldProduct),
              pw.Row(children: [
                pw.Expanded(
                    child: pw.Column(children: [
                      pw.SizedBox(width: 200, child: pw.Divider()),
                      pw.Text('Investor Signature',style: pw.TextStyle(fontWeight: pw.FontWeight.bold),)
                    ])),
                pw.Expanded(child: pw.Container()),
                pw.Expanded(
                    child: pw.Column(children: [
                      pw.SizedBox(width: 200, child: pw.Divider()),
                      pw.Text('Company Signature',style: pw.TextStyle(fontWeight: pw.FontWeight.bold),)
                    ])),
              ]),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  Future<Uint8List> createPaymentReceipt(
      Purchase soldProduct,int amount,DateTime dateTime) async {
    final pdf = pw.Document();

    final image =
    (await rootBundle.load("assets/dart.png")).buffer.asUint8List();
    final paidImage = (await rootBundle.load('assets/paid-5025785_1920.png')).buffer.asUint8List();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [

              pw.Image(pw.MemoryImage(image),
                  width: 200, height: 101, fit: pw.BoxFit.fill),
              pw.SizedBox(height: 50),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Customer Name : ${soldProduct.customerName}",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),

                      pw.Text(
                        "Product Name : ${soldProduct.productName}",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),

                      ),
                      pw.Text(
                        "Purchase Date: ${DateFormat.yMMMMd().format(soldProduct.purchaseDate.toDate())}",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),

                      ),

                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 50),
              pw.Column(children: [
                pw.Row(
                  children: [
                    pw.Expanded(
                        child: pw.Text("Date",style: pw.TextStyle(fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.left)),
                    pw.Expanded(
                        child:
                        pw.Text("", textAlign: pw.TextAlign.right)),
                    pw.Expanded(
                        child: pw.Text("",
                            textAlign: pw.TextAlign.right)),
                    pw.Expanded(
                        child: pw.Text("Amount",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.right)),
                  ],
                ),
                pw.Divider()
              ]),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    pw.Column(children: [
                      pw.Row(
                        children: [
                          pw.Expanded(
                              child: pw.Text(
                                  DateFormat.yMMMMd().add_jm().format(dateTime),style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                  textAlign: pw.TextAlign.left)),
                          pw.Expanded(
                              child: pw.Text('',
                                  textAlign: pw.TextAlign.right)),
                          pw.Expanded(
                              child: pw.Text('',
                                  textAlign: pw.TextAlign.right)),
                          pw.Expanded(
                              child: pw.Text(amount.toString(),style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                  textAlign: pw.TextAlign.right)),
                        ],
                      ),
                      pw.Divider(),
                    ]),
                    pw.Column(
                      children: [
                        pw.Row(
                          children: [
                            pw.Expanded(child: pw.Text("", textAlign: pw.TextAlign.left)),
                            pw.Expanded(
                                child: pw.Text("", textAlign: pw.TextAlign.right)),
                            pw.Expanded(
                                child: pw.Text("Total Outstanding",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                    textAlign: pw.TextAlign.right)),
                            pw.Expanded(
                                child: pw.Text(
                                    '${soldProduct.outstandingBalance.toString()} PKR',style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                    textAlign: pw.TextAlign.right)),
                          ],
                        ),
                        pw.Divider()
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Row(
                          children: [
                            pw.Expanded(child: pw.Text("", textAlign: pw.TextAlign.left)),
                            pw.Expanded(
                                child: pw.Text("", textAlign: pw.TextAlign.right)),
                            pw.Expanded(
                                child: pw.Text("Total Amount Paid",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                    textAlign: pw.TextAlign.right)),
                            pw.Expanded(
                                child: pw.Text('${soldProduct.amountPaid.toString()} PKR',style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                    textAlign: pw.TextAlign.right)),
                          ],
                        ),
                        pw.Divider()
                      ],
                    ),
                    pw.SizedBox(height: 50),
                    pw.Center(child: pw.Image(pw.MemoryImage(paidImage),
                        width: 200, height: 200, fit: pw.BoxFit.fill),)
                  ],
                ),
              ),
              pw.Row(children: [
                pw.Expanded(child: pw.Container()),
                pw.Expanded(child: pw.Container()),

              ]),pw.Header(text: 'Payment Receipt',textStyle: pw.TextStyle(fontItalic: pw.Font.timesItalic(),fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  pw.Expanded paymentScheduleColumn(
      List<PaymentSchedule> elements, Purchase soldProduct) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          for (var element in elements)
            pw.Column(children: [
              pw.Row(
                children: [
                  pw.Expanded(
                      child: pw.Text(
                          DateFormat.yMMMMd().format(element.date.toDate()),style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.left)),
                  pw.Expanded(
                      child: pw.Text(element.amount.toString(),style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right)),
                  pw.Expanded(
                      child: pw.Text(element.remainingAmount.toString(),style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right)),
                  pw.Expanded(
                      child: pw.Text(element.isPaid ? 'Paid' : 'Not Paid',style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right)),
                ],
              ),
              pw.Divider(),
            ]),
          pw.Column(
            children: [
              pw.Row(
                children: [
                  pw.Expanded(child: pw.Text("", textAlign: pw.TextAlign.left)),
                  pw.Expanded(
                      child: pw.Text("", textAlign: pw.TextAlign.right)),
                  pw.Expanded(
                      child: pw.Text("Total Outstanding",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right)),
                  pw.Expanded(
                      child: pw.Text(
                          '${soldProduct.outstandingBalance.toString()} PKR',style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right)),
                ],
              ),
              pw.Divider()
            ],
          ),
          pw.Column(
            children: [
              pw.Row(
                children: [
                  pw.Expanded(child: pw.Text("", textAlign: pw.TextAlign.left)),
                  pw.Expanded(
                      child: pw.Text("", textAlign: pw.TextAlign.right)),
                  pw.Expanded(
                      child: pw.Text("Total Amount Paid",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right)),
                  pw.Expanded(
                      child: pw.Text('${soldProduct.amountPaid.toString()} PKR',style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right)),
                ],
              ),
              pw.Divider()
            ],
          ),
        ],
      ),
    );
  }

  pw.Expanded itemColumn(List<CustomRow> elements) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          for (var element in elements)
            pw.Column(children: [
              pw.Row(
                children: [
                  pw.Expanded(
                      child: pw.Text(element.itemName,style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.left)),
                  pw.Expanded(
                      child: pw.Text(element.itemPrice,style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right)),
                  pw.Expanded(
                      child: pw.Text(element.amount,style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right)),
                  pw.Expanded(
                      child: pw.Text(element.total,style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right)),
                ],
              ),
              pw.Divider()
            ])
        ],
      ),
    );
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenFilex.open(file.path);
  }
}
