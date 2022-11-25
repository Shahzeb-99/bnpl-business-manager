import 'package:flutter/material.dart';

class VendorWidget extends StatelessWidget {
  const VendorWidget({
    Key? key,
    required this.price,
    required this.image,
    required this.name,
  }) : super(key: key);

  final String image;
  final String name;
  final int price;

  @override
  Widget build(BuildContext context) {
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
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(500)),
                height: MediaQuery.of(context).size.height * 0.10,
                width: MediaQuery.of(context).size.height * 0.10,
                child: Image.network(
                  image,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Price : $price PKR'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
