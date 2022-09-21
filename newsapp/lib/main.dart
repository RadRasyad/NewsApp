
import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/common/navigation.dart';
import 'package:newsapp/data/api/api_service.dart';
import 'package:newsapp/data/db/database_helper.dart';
import 'package:newsapp/data/preferences/preferences_helper.dart';
import 'package:newsapp/provider/database_provider.dart';
import 'package:newsapp/provider/news_provider.dart';
import 'package:newsapp/provider/preferences_provider.dart';
import 'package:newsapp/provider/scheduling_provider.dart';
import 'package:newsapp/ui/detail_page.dart';
import 'package:newsapp/data/model/article.dart';
import 'package:newsapp/ui/article_webview.dart';
import 'package:newsapp/ui/home_page.dart';
import 'package:newsapp/utils/background_service.dart';
import 'package:newsapp/utils/notification_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'News App',
            theme: provider.themeData,
            builder: (context, child) {
              return CupertinoTheme(
                data: CupertinoThemeData(
                  brightness:
                  provider.isDarkTheme ? Brightness.dark : Brightness.light,
                ),
                child: Material(
                  child: child,
                ),
              );
            },
            navigatorKey: navigatorKey,
            initialRoute: HomePage.routeName,
            routes: {
              HomePage.routeName: (context) => const HomePage(),
              ArticleDetailPage.routeName: (context) => ArticleDetailPage(
                article:
                ModalRoute.of(context)?.settings.arguments as Article,
              ),
              ArticleWebView.routeName: (context) => ArticleWebView(
                url: ModalRoute.of(context)?.settings.arguments as String,
              ),
            },
          );
        },
      ),
    );
  }
}