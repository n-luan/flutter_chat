import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {this.id,
      this.current_user_id,
      this.name,
      this.text,
      this.animationController});
  final int id;
  final int current_user_id;
  final String text;
  final String name;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    if (current_user_id == id) {
      return _buildRight(context);
    } else {
      return _build(context);
    }
  }

  Widget _build(BuildContext context) {
    var container = new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(child: new Text(name[0])),
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(name, style: Theme.of(context).textTheme.title),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if (animationController != null) {
      return new SizeTransition(
          sizeFactor: new CurvedAnimation(
              parent: animationController, curve: Curves.easeOut),
          axisAlignment: 0.0,
          child: container);
    } else {
      return container;
    }
  }

  Widget _buildRight(BuildContext context) {
    var container = new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Expanded(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(name, style: Theme.of(context).textTheme.title),
              new Container(
                margin: const EdgeInsets.only(top: 5.0, right: 4.0),
                child: new Text(text),
              ),
            ],
          ),
        ),
        new Container(
          margin: const EdgeInsets.only(right: 16.0, left: 2.0),
          child: new CircleAvatar(child: new Text(name[0])),
        ),
      ],
    );

    if (animationController != null) {
      return new SizeTransition(
          sizeFactor: new CurvedAnimation(
              parent: animationController, curve: Curves.easeOut),
          axisAlignment: 0.0,
          child: new Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: container,
          ));
    } else {
      return container;
    }
  }
}
