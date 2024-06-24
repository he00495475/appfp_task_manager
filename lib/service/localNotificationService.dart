import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

/// 初始化套件
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

///建一個Service類別來管理
class LocalNotificationService {
  ///第幾則通知
  var id = 0;

  static Future<void> init() async {
    tz.initializeTimeZones(); // 初始化時區資料庫
    tz.setLocalLocation(tz.getLocation('Asia/Taipei')); // 將時區設定為台北標準時間
  }

  static Future<void> initialize() async {
    ///初始化在Android上的通知設定
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    ///初始化在iOS上的通知設定
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );

    ///設定組合
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        ///收到通知要做的事
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  ///跳出通知
  ///(自定的部份，如果你有用到Firebase來發送訊息，要和Firebase設定的一樣，不然不會有投頭顯示)
  Future<void> showNotification(DateTime dateTime, String title) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('通道id', '通道名稱',
            channelDescription: '任務通知',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      333, // 通知ID，必须是唯一的
      '任務已逾期',
      title,
      _nextInstanceOfTime(dateTime), // DateTime对象，指定通知发送的时间
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    // 直接顯示的方法
    // await flutterLocalNotificationsPlugin.show(
    //     id++, '標題', '內容', notificationDetails,
    //     payload: '要帶回程式的資料(如果有做點按後回到程式的功能)');
  }

  static tz.TZDateTime _nextInstanceOfTime(DateTime time) {
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, time.year, time.month, time.day, time.hour, time.minute);

    return scheduledDate;
  }
}

///注意，這個方法不能是class內的方法，要是靜態，或宣告在外層的方法
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (notificationResponse.input?.isNotEmpty ?? false) {
    ///確認有帶值進來時，程式要做的動作
  }
}
