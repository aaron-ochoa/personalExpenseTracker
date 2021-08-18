import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupTransactionValues {
    //always returns the amount and you want so in this case 7 for the 7 days of
    //the week -> then always takes in index (kind of like a for loop) will execute
    //the function for each index
    return List.generate(7, (index) {
      //getting the current day minus the index(days) using the duration object
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      //getting the total number of money spent using a for-loop
      var totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      //will return the map that you generated key and value 'day': 'T', 'amount': 9.99
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
      //to make the days so from left being the oldest and the right to newest
    }).reversed.toList();
  }

  //creating a getter to be able to calculate the total spending for the week
  double get totalAmount {
    //fold allows you to change a list to another type depending on the function you pass to it
    //take in two elements the starting value and the value
    return groupTransactionValues.fold(0.0, (previousValue, element) {
      return previousValue + element['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      //Padding is a kind of container that is just for padding
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          //refers to the list that the transaction values returns
          //also map the transactions to a widgets
          children: groupTransactionValues.map((data) {
            //if there is long text then this restricts the amount of space it can take
            //in this case is will shrink the text
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalAmount == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalAmount),
            );
          }).toList(),
        ),
      ),
    );
  }
}
