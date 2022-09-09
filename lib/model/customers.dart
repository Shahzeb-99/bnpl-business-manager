class Customers {
  Customers(
      {required this.name,
      required this.image,
      required this.outstanding_balance,
      required this.paid_amount,
      required this.documentID});

  final String name;
  final String image;
  final int outstanding_balance;
  final int paid_amount;
  final String documentID;

}
