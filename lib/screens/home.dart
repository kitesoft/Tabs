import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabs/controllers/tabsController.dart';
import 'package:tabs/screens/create.dart';
import 'package:tabs/screens/welcome.dart';
import 'package:tabs/services/auth.dart';
import 'package:tabs/tabsList.dart';

class Home extends StatelessWidget {
  static const String id = "home_screen";
  final String uid;
  Home(this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(
                    MediaQuery.of(context).size.width * 0.50, 18),
                bottomRight: Radius.elliptical(
                    MediaQuery.of(context).size.width * 0.50, 18),
              ),
            ),
          ),
          Positioned(
            top: 25,
            right: 5,
            child: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Auth.signOut();
                Navigator.pushReplacementNamed(context, Welcome.id);
              },
            ),
          ),
          SafeArea(
            child: StreamProvider(
              builder: (context) => TabsController.getUsersTabs(this.uid),
              child: TabsList(),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Create.id);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
