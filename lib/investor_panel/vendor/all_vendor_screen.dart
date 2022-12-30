import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_bnql/investor_panel/vendor/vendor_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../investor_panel/view_model/viewmodel_vendors.dart';

class AllVendorScreen extends StatefulWidget {
  const AllVendorScreen({Key? key}) : super(key: key);

  @override
  State<AllVendorScreen> createState() => _AllVendorScreenState();
}

class _AllVendorScreenState extends State<AllVendorScreen> {
  final cloud = FirebaseFirestore.instance;

  @override
  void initState() {
    Provider.of<VendorViewInvestor>(context, listen: false).getVendors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:  const Text(
          'Investors ',
          style: TextStyle(fontSize: 25,color:  Color(0xFFE56E14),),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: ListView.builder(
            physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount:
                Provider.of<VendorViewInvestor>(context).allVendors.length,
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VendorProfile(index: index)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: 'https://cdn-icons-png.flaticon.com/512/147/147144.png',
                          height: 60,
                          width: 60,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Provider.of<VendorViewInvestor>(context)
                                    .allVendors[index]
                                    .name!,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                                softWrap: true,
                              ),
                              Text(
                                'Opening Balance : ${Provider.of<VendorViewInvestor>(context).allVendors[index].openingBalance.toString()}',
                                softWrap: true,
                              ),
                              Text(
                                'Current Balance : ${Provider.of<VendorViewInvestor>(context).allVendors[index].currentBalance.toString()}',
                                softWrap: true,
                              ),
                            ],
                          ),
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
