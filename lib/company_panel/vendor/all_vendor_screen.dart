import 'package:ecommerce_bnql/company_panel/vendor/vendor_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../view_model/viewmodel_vendors.dart';

class AllVendorScreen extends StatefulWidget {
  const AllVendorScreen({Key? key}) : super(key: key);

  @override
  State<AllVendorScreen> createState() => _AllVendorScreenState();
}

class _AllVendorScreenState extends State<AllVendorScreen> {
  final cloud = FirebaseFirestore.instance;

  @override
  void initState() {
    Provider.of<VendorView>(context, listen: false).getVendors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(



        title:  const Text(
          'Vendors',
          style: TextStyle(  fontSize: 25,color:Color(0xFFE56E14),),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:10,horizontal: 10),
          child: ListView.builder(
            physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: Provider.of<VendorView>(context).allVendors.length,
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
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              Provider.of<VendorView>(context, listen: false)
                                  .allVendors[index]
                                  .image),
                          radius: 30,
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
                                Provider.of<VendorView>(context, listen: false)
                                    .allVendors[index]
                                    .name,
                                style: kBoldText,
                              ),
                              Text(
                                Provider.of<VendorView>(context)
                                    .allVendors[index]
                                    .address,
                                softWrap: true,
                              )
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
