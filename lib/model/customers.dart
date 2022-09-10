class Customers {
  Customers(
      {required this.name,
      required this.image,
      required this.outstandingBalance,
      required this.paidAmount,
      required this.documentID});

  final String name;
  final String image;
  final int outstandingBalance;
  final int paidAmount;
  final String documentID;

}
