import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/adaptive_flat_button.dart';

//need to convert this file from a stateless widget to a stateful widget
//to hold each of the values for the input fields so that they dont disappear
//when you go to the next one (adds a layer of seperation between data and UI)
class NewTransaction extends StatefulWidget {
  //this is will be used to save the text from user input
  //the TextEditingController can be assigned to the text fields
  final Function selectHandler;

  NewTransaction(this.selectHandler);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  //Variable for the data picker
  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    //getting each of the text that is enter - these will be passed to an if-else statement
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    //passing the select handler as a function with the arguements
    widget.selectHandler(enteredTitle, enteredAmount, _selectedDate);

    //popping the last context layer of the UI off - like a stack
    Navigator.of(context).pop();
  }

  //Date picker method...flutter already gives us a default date picker object to use
  void _presentDatePicker() {
    //show date picker takes four inputs
    //context, the intialDate, FirstDate user is allowed to choose and the last date
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //DateTime accepts the year you want to be allowed to choose from as a constructor
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        //the then arguement is used wait for something to happen to store the wanted information
        //in this case it will wait to save the date until the user clicks OK
        //otherwise usually the code will not wait to execute - and will just
        //execute when the user opens the date picker
        //then the method will execute a function once it resolves a value
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      //will tell dart to refresh the page with the selected date
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              //getting how much the softkeyboard may take and adding a padding of ten
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //Creating a input field for the user
              TextField(
                //creating the label within the field
                decoration: InputDecoration(labelText: 'Title'),
                //this listens and saves the user input
                controller: _titleController,
                //dont think onsubmitt works in ios situations
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                //this listens and saves within the field
                controller: _amountController,
                //only opens the keyboard with the numbers and decimal point available
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                //on submitted required that a function to take a string this is why
                //we are using an annonimous functions and it is convention to pass
                //in the _ when doing this

                //ios does not have a done button when entering numbers so this is not needed
                // onSubmitted: (_) => submitData,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}'),
                    ),
                    Adaptive_flat_button('Choose Date', _presentDatePicker),
                  ],
                ),
              ),
              //creating a transaction button
              RaisedButton(
                  onPressed: _submitData,
                  child: Text(
                    'Add Transaction',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.button.color,
                    ),
                  ),
                  color: Theme.of(context).primaryColor)
            ],
          ),
        ),
      ),
    );
  }
}
