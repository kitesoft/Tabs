import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:tabs/controllers/tabsController.dart';
import 'package:tabs/widgets/changeAmountDialog.dart';
import 'package:intl/intl.dart';

class TabModal extends StatelessWidget {
  final DocumentSnapshot tab;
  TabModal({@required this.tab});

  @override
  Widget build(BuildContext context) {
    String displayAmount =
        FlutterMoneyFormatter(amount: this.tab["amount"]).output.symbolOnLeft;
    DateFormat formatter = DateFormat("yyyy/MM/dd");
    String formattedDateOpened =
        formatter.format(DateTime.parse(this.tab["time"].toDate().toString()));
    return Container(
      height: 450,
      margin: EdgeInsets.only(left: 18, right: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5],
          colors: [
            Colors.white,
            Colors.white.withAlpha(250),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
                this.tab["userOwesFriend"] == true
                    ? "I Owe ${this.tab["name"]}"
                    : "${this.tab["name"]}'s Tab",
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(
              "$formattedDateOpened",
              style: Theme.of(context).textTheme.overline,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    "Amount",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "${this.tab["description"]}",
                  style: Theme.of(context).textTheme.subtitle,
                ),
                Text(
                  "$displayAmount",
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ],
            ),
            Expanded(
              child: Image(
                image: AssetImage(
                  this.tab["userOwesFriend"] == true
                      ? 'assets/graphics/together.png'
                      : 'assets/graphics/money-guy.png',
                ),
                fit: BoxFit.contain,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  child: Text(this.tab["closed"] == true
                      ? "Reopen Tab"
                      : "Change Amount"),
                  onPressed: () {
                    if (this.tab["closed"] == true) {
                      TabsController.reopenTab(this.tab.documentID);
                      Navigator.pop(context);
                    } else
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ChangeAmountDialog(tab: this.tab);
                          });
                  },
                ),
                RaisedButton(
                  child:
                      Text(this.tab["closed"] == true ? "Delete" : "Close Tab"),
                  onPressed: () {
                    this.tab["closed"] == true
                        ? TabsController.deleteTab(this.tab.documentID)
                        : TabsController.closeTab(this.tab.documentID);
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
