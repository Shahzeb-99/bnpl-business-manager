import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/vendors.dart';

class BatchOrderInvestorWidget extends StatefulWidget {
  const BatchOrderInvestorWidget({required this.investorList, Key? key, required this.index, required this.investorsList, required this.onChanged}) : super(key: key);
  final List<String> investorList;
  final int index;
  final List<Investors> investorsList;
  final Function(int) onChanged;

  @override
  State<BatchOrderInvestorWidget> createState() => _BatchOrderInvestorWidgetState();
}

class _BatchOrderInvestorWidgetState extends State<BatchOrderInvestorWidget> {
  bool isChecked = false;
  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(
          children: [
            Theme(
              data: Theme.of(context).copyWith(unselectedWidgetColor: const Color(0xFFE56E14)),
              child: CheckboxListTile(
                subtitle: Text('Current Balance : ${widget.investorsList[widget.index].currentBalance}'),
                activeColor: const Color(0xFFE56E14),
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    setState(() {
                      widget.onChanged(0);
                    });
                    isChecked = value!;
                    textController.clear();
                  });
                },
                title: Text(widget.investorList[widget.index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
              child: TextField(
                controller: textController,
                enabled: isChecked,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: kDecoration.inputBox('Investment Amount', 'PKR'),
                onChanged: (value) {
                  setState(() {
                    widget.onChanged(int.parse(value));
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
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
      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      hintText: hintText,
    );
  }
}
