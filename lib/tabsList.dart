import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuerySnapshot>(
      builder: (context, tabsData, child) {
        return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: tabsData.documents.length,
            itemBuilder: (context, index) {
              return TabCard(
                tab: tabsData.documents[index],
              );
            });
      },
    );
  }
}

class TabCard extends StatelessWidget {
  final DocumentSnapshot tab;
  TabCard({@required this.tab});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(this.tab["amount"].toString()),
            subtitle: Text(this.tab["name"]),
            trailing: Icon(Icons.receipt),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('PAID'),
                  onPressed: () async {
                    try {
                      await Firestore.instance
                          .collection("tabs")
                          .document(this.tab.documentID)
                          .delete();
                    } catch (e) {}
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}