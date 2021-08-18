import 'dart:io';
//convention to have all dart import - 3rd party packages - then widgets
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//Need to have this imported to limit device orientation
//import 'package:flutter/services.dart';

//before importing this package you need to add the dependency to the pubspec.yaml file
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() {
  //will tell the program which device orientations to allow when building the app
  /*  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft
  ]); */
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      // sets a theme color for the app with secondary colors
      // accentColor is like the backup color that some widgets will use automatically
      // theme is where always you can set new global fonts that you defined in the
      // pubspec.yaml
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          //making a different default font for the other title within the app
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                button: TextStyle(color: Colors.white),
              ),

          //also able to set a default appBar theme in case you want the app to look different
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))),
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

//add this to every stateful class so it can tell when the app is running, paused, suspended
//or killed
class _HomepageState extends State<Homepage> with WidgetsBindingObserver {
  //create two transactions so the app can have some data at the begining
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    // Transaction(
    //     id: 't2',
    //     title: 'Weekly Groceries',
    //     amount: 16.53,
    //     date: DateTime.now())
  ];

  bool _showChart = false;

  //adding a listener
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifeCycleState(AppLifecycleState state) {
    print(state);
  }

  //also want to clear this when the state object is no longer needed
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //creating a function to make a new transaction

  List<Transaction> get recentTransactions {
    //using the where arguement instead of a for-loop
    //where -> get the element from the list
    return _userTransactions.where((element) {
      //getting the past 7 days
      return element.date.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTtile, double txAmount, DateTime choosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTtile,
        amount: txAmount,
        date: choosenDate);

    //changing the userTransaction because it is just a pointer - cannot change the variable '='
    //but can change the refernce with .add()
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  //finding the transaction to delete with the string id as the primary indetefier
  void _deleteTransaction(String id) {
    setState(() {
      //uses the string id to find and remove the correct transaction
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _starAddNewTransaction(BuildContext ctx) {
    //the showModalBottomSheet needs two arguements
    //one is the content which we get from the scaffold below and this is what is passed into this function
    //second is the builder function that returns the widget that should be in the
    //showModalBottomSheet needs are context and returns something
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          //calling a point to the add new transaction method
          return NewTransaction(_addNewTransaction);
        });
  }

  //builder method returns a widget - calls a method to outsource from the main file
  //just to make the code more readable
  List<Widget> _buildLandscapeContent(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart', style: Theme.of(context).textTheme.headline6),
          //toggle switch
          //some widgets have the ability to become adaptive and show the
          //UI would expect to be for Iphone vs. Andriod this is when you use
          //the .adaptive constructor
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          )
        ],
        //if/else expression on whether or not to show the chart
      ),
      _showChart
          ? Container(
              //getting the height of the device
              height: (mediaQuery.size.height -
                      //subtracting the height of the appBar
                      appBar.preferredSize.height -
                      //subtracting the height of the status bar on top of the app
                      mediaQuery.padding.top) *
                  //what percentage of the device this container will take up
                  .7,
              child: Chart(recentTransactions))
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Container(
          //getting the height of the device
          height: (mediaQuery.size.height -
                  //subtracting the height of the appBar
                  appBar.preferredSize.height -
                  //subtracting the height of the status bar on top of the app
                  mediaQuery.padding.top) *
              //what percentage of the device this container will take up
              .3,
          child: Chart(recentTransactions)),
      txListWidget
    ];
  }

  Widget _buildIosNavigationBar() {
    return CupertinoNavigationBar(
      middle: Text('Personal Expenses'),
      trailing: Row(
        //setting this to miminize the row
        mainAxisSize: MainAxisSize.min,
        children: [
          //IOS does not have IconButton so you need to build your own
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _starAddNewTransaction(context),
          )
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Personal Expenses'),
      //adding button in appbar
      actions: [
        IconButton(
            icon: Icon(Icons.add),
            //need to call a anyonmous function and pass the context to it
            onPressed: () => _starAddNewTransaction(context))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //if you find yourself using MediaQuery a lot it is best practice to just store it
    //in a variable
    final mediaQuery = MediaQuery.of(context);
    //gets the orientation of the device and sees if its equal to landscape mode
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar =
        Platform.isIOS ? _buildIosNavigationBar() : _buildAppBar();
    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            .7,
        child: TransactionList(_userTransactions, _deleteTransaction));
    //saving the body of the page in a variable so it can be used for IOS and andriod
    //using SafeArea helps respect the new IOS devices top and bottom space that should
    //not be used for positioning
    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //if isLandscape is true then this switch button will show
          //if isLandscape is false then the switch button will not show
          if (isLandscape)
            ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
          //if statement to see whether or not to show this widget according to the
          //orentation
          if (!isLandscape)
            //the ... is to "flatten out" a list of widgets
            //since the column can only accept a single widget return the ... will help
            //solve this problem
            ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
        ],
      ),
    ));
    //will show the cupertino widgets if it is an IOS device
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            //makes the wholes list
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            //bottom button
            //checks to see if this is an IOS platform and returns true or false then does
            //not show the button if it is an IOS device
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _starAddNewTransaction(context),
                  ),
          );
  }
}
