import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'dart:async';
import 'package:reading_retention_tool/module/notification_data.dart';
import 'package:reading_retention_tool/plugins/highlightNotificationPlugin.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';


class CreateNotificationPage extends StatefulWidget {

  final List objNotifications;
  final String categoryId;


  CreateNotificationPage(this.objNotifications, this.categoryId);

  @override
  _CreateNotificationPageState createState() => _CreateNotificationPageState();
}

class _CreateNotificationPageState extends State<CreateNotificationPage> with SingleTickerProviderStateMixin {

  TimeOfDay selectedTime = TimeOfDay.now();
  final HighlightNotificationPlugin _notificationPlugin = HighlightNotificationPlugin();
  Future<List<PendingNotificationRequest>> notificationFuture;

  AnimationController _fadeInController;


  @override
  void initState() {

    super.initState();

    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    notificationFuture = _notificationPlugin.getScheduledNotifications();

  }

  @override
  void dispose() {
    super.dispose();
    _fadeInController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: kDarkColorBlack),
        elevation: 0.0,
        title: Text('Create Notification'),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
            },
            padding: EdgeInsets.all(0.0),
            iconSize: 100.0,
            icon: Image.asset(
              'Images/quotd.png',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

         /*   StreamBuilder<List<NotificationData>>(
              stream: Provider.of<AppData>(context).outNotifications,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print("Hi");
                  final notifications = snapshot.data;
                  _fadeInController.forward();
                  if (notifications.isEmpty)
                    return Expanded(
                      child: Center(
                        child: Image.asset(
                          'Images/create_notification.png',
                          width: 300,
                          height: 300,
                        ),
                      ),
                    );
                  return Expanded(
                    child: AnimatedBuilder(
                      animation: _fadeInController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeInController.value,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final notification = notifications[index];
                              return NotificationTile(
                                notification: notification,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
                return Expanded(child: SizedBox());
              },
            ),*/
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                     Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.asset(
                              'Images/create_notification.png',
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      OutlineButton(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        onPressed: selectTime,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.access_time),
                            SizedBox(width: 4),
                            Text(selectedTime.format(context)),
                          ],
                        ),
                      ),
                    ],
                  ),
              ),
            ),

            OutlineButton(
              disabledBorderColor: kPrimaryColor,
              onPressed: () => createNotification(),
              child: Text('Create Notification',
                style: TextStyle(
                    color: kPrimaryColor,
                    letterSpacing: 1
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  void createNotification() {

     final objData = widget.objNotifications;
     List<NotificationData> notificationData = [];

     objData.forEach((val){
       notificationData.add(NotificationData(widget.categoryId, val, selectedTime.hour, selectedTime.minute));

     });

     Provider.of<AppData>(context).addNotification(notificationData, widget.categoryId);


     Navigator.popAndPushNamed(context, HomeScreen.id);
     //Navigator.of(context).pop();
    }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    Key key,
    @required this.notification,
  }) : super(key: key);

  final NotificationData notification;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    notification.title,
                    style: textTheme.title.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    notification.description,
                    style: textTheme.subtitle.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        size: 28,
                        color: Theme
                            .of(context)
                            .accentColor,
                      ),
                      SizedBox(width: 12),
                      Text(
                        '${notification.hour.toString().padLeft(
                            2, '0')}:${notification.minute.toString().padLeft(
                            2, '0')}',
                        style: textTheme.headline.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme
                              .of(context)
                              .brightness == Brightness.dark ? Colors.grey
                              .shade300 : Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: null,
              icon: Icon(Icons.delete, size: 32),
            ),
          ],
        ),
      ),
    );
  }
  SizedBox get smallHeight => SizedBox(height: 8);
}
