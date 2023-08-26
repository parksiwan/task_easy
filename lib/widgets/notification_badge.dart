import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  //final int totalNotifications;
  //const NotificationBadge({required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: new BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.note, color: Colors.blueAccent),
        ),
      ),
    );
  }
}
