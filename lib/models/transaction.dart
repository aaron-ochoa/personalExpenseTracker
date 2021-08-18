//to use the @required you need to import the foundation.dart package
//since we are not using the martial.dart package in this class

import 'package:flutter/foundation.dart';

//simply defining how a transaction should look like
class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

//creating the named arguments for this constructor
  Transaction(
      {@required this.id,
      @required this.title,
      @required this.amount,
      @required this.date});
}
