import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

//seperated this widget from the transaction_list widget to make that widget smaller
//and more readable
class TransactionItem extends StatefulWidget {
  const TransactionItem({
    //stateless widgets do need a key/ some stateful widgets need a key
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
//creating a initial state where the circile is one of the below colors

  Color _bgColor;

  @override
  void initState() {
    const availableColors = [
      Colors.red,
      Colors.black,
      Colors.blue,
      Colors.purple
    ];
    //doesnt need to wrap in setState because build runs after this
    //generating a random number 1-4 to get the color
    _bgColor = availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        //a widget that is postioned at the begining of the listTile
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(child: Text('\$${widget.transaction.amount}')),
          ),
        ),
        title: Text(widget.transaction.title,
            style: Theme.of(context).textTheme.headline6),
        subtitle: Text(DateFormat.yMMMd().format(widget.transaction.date)),
        //Getting the device size to know if it is suppose to show the
        //delete text or not
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                label: Text('Delete'),
                textColor: Theme.of(context).errorColor,
                onPressed: () => widget.deleteTx(widget.transaction.id),
              )
            : IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                //need to pass a function to be able to be able to pass a reference to the function
                //and within the function you can pass the transaction id
                onPressed: () => widget.deleteTx(widget.transaction.id),
              ),
      ),
    );
  }
}
// Card(
//   //creating a row inside the column to show the price, title and date
//   //this will require another column inside the row we are just creating
//   child: Row(
//     children: [
//       Container(
//         //styling the container
//         margin:
//             //creating margin around the price
//             EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//         //making a box outline
//         decoration: BoxDecoration(
//             border: Border.all(
//                 color: Theme.of(context).primaryColor,
//                 width: 2)),
//         padding: EdgeInsets.all(10),
//         child: Text(
//           //the ${} automaticatlly calls the .toString() method on the value
//           //it just lookd cleaner
//           //the item build passes through and index which now can be passed
//           //to the transactions list and return the correct value
//           '\$${transactions[index].amount.toStringAsFixed(2)}',
//           style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//               color: Theme.of(context).primaryColor),
//         ),
//       ),
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             //what was previously tx.title is being turned in to transaction[index].title
//             transactions[index].title,
//             style: Theme.of(context).textTheme.headline6,
//           ),
//           Text(
//             //formatting the date using the intl package
//             DateFormat.yMMMd().format(transactions[index].date),
//             style: TextStyle(color: Colors.grey),
//           ),
//         ],
//       )
//     ],
//   ),
// );
