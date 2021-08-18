import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPCTOfTotal;

  //a constructor can only be const if all of its variables are final
  //this will help to optimize the final runtime
  const ChartBar(this.label, this.spendingAmount, this.spendingPCTOfTotal);

  @override
  Widget build(BuildContext context) {
    //layout builder needs the context and some constraints
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: [
          //will make the text shrink in the box that this creates
          Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                  child: Text('\$${spendingAmount.toStringAsFixed(0)}'))),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            //using the constraints that this widget is getting so you dont have
            //to change this function everytime you change the about of space this
            //widget is given from the main function
            height: constraints.maxHeight * 0.6,
            width: 10,
            //allows you to put widget on top of each other in the 3D sense not like
            //a column
            child: Stack(
              children: [
                //first widget is the bottom most widget
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // a box that fill a fraction of the underlying widget
                FractionallySizedBox(
                  heightFactor: spendingPCTOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: constraints.maxHeight * 0.05),
          Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(child: Text(label))),
        ],
      );
    });
  }
}
