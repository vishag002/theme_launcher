import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme_launcher/views/apps_screen.dart';
import 'package:theme_launcher/views/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Move SystemChrome styling here so it updates with theme changes
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Theme.of(context).colorScheme.primary,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      if (_pageController.page != 0) {
        _pageController.jumpToPage(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageController.page == 1) {
          _pageController.jumpToPage(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          children: const [
            HomeScreen(),
            AppListScreen(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }
}
