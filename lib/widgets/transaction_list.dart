import 'package:flutter/material.dart';

import './transaction_item.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  //creating a constructor to pass the transaction list
  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return Container(
      //giving the container a clearly defined height
      //height: 550,
      //scrollable view for just the transaction list
      //child: SingleChildScrollView(

      //listview is a column or row that is automatically scrollable

      //adding if else statement to see if there are any transaction to show
      child: transactions.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints) {
              return Column(
                children: [
                  Text(
                    'No transactions added yet.',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  //creates an empty box to create some space inbetween the text and image
                  SizedBox(
                    height: 20,
                  ),
                  //how to show an image
                  Container(
                      height: constraints.maxHeight * 0.6,
                      //200,
                      //at the first image is too large and will not fit within the scree
                      //making an error. So creating a container around it will make
                      //the image fit to the size using BoxFit.cover
                      child: Image.asset('assets/images/waiting.png',
                          fit: BoxFit.cover))
                ],
              );
            })
          : ListView(
              //flutter only matches the element to the widget tree not the context
              children: // so in a list multiple of the same elements exist which is why we need key to keep tract
                  //ListView.builder(   //only really need keys for a list view with stateful children
                  //needed for listview.builer
                  //itemBuilder: (ctx, index) {
                  //below is the alternative to using a custom card
                  transactions
                      .map((tx) => TransactionItem(
                          key: ValueKey(
                              tx.id), //setting the key value to the widget id
                          transaction: tx,
                          deleteTx: deleteTx))
                      .toList()),

      //itemCount: transactions.length,
      //the tx is when the transaction map get a single transaction
      //children: transactions.map((tx) {
      //each transaction will get a card of its own
      // }).toList(),
    );
  }
}
