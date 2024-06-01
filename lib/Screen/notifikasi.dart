import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class Notifikasi extends StatefulWidget {
  const Notifikasi({super.key});

  @override
  State<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification
    );
    _scheduleWeeklyFridayTenAMNotification();
    _scheduleDailySevenAMNotification();
  }

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Detail Notifikasi'),
          content: Text(payload),
        ),
      );
    }
  }

  Future<void> _scheduleWeeklyFridayTenAMNotification() async {
    var now = tz.TZDateTime.now(tz.local);
    var time = tz.TZDateTime(tz.local, now.year, now.month, now.day, 10, 0);
    if (time.weekday != DateTime.friday) {
      time = tz.TZDateTime.from(time.add(Duration(days: (7 - time.weekday + DateTime.friday) % 7)), tz.local);
    }

    final AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
      'weekly_notification_channel_id',
      'Weekly Notification',
      'Weekly Notification Channel for Donations',
      importance: Importance.max,
      priority: Priority.high,
    );
    final NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Waktu Berdonasi',
      'Mari berdonasi setiap Jumat jam 10 pagi!',
      time,
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> _scheduleDailySevenAMNotification() async {
    var time = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));
    time = tz.TZDateTime(tz.local, time.year, time.month, time.day, 7, 0);

    final AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
      'daily_notification_channel_id',
      'Daily Motivation',
      'Daily Motivation Notification Channel',
      importance: Importance.max,
      priority: Priority.high,
    );
    final NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.periodicallyShow(
      1,
      'Motivasi Pagi',
      'Mulai hari Anda dengan semangat!',
      RepeatInterval.daily,
      platformDetails,
      androidAllowWhileIdle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NOTIFIKASI',
          style: TextStyle(
            color: Color(0xFFA4C751),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _scheduleDailySevenAMNotification,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/new_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ListTile(
                leading: const Icon(Icons.circle, color: Color(0xFFA4C751)),
                title: const Text('Saatnya donasi'),
                onTap: _scheduleWeeklyFridayTenAMNotification,
              ),
            );
          },
        ),
      ),
    );
  }
}