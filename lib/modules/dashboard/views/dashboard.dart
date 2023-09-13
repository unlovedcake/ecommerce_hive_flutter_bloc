import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/Logger/my_logger.dart';
import 'package:hive/modules/dashboard_chat/views/chat.dart';
import 'package:hive/modules/dashboard_home/views/home.dart';
import 'package:hive/modules/dashboard_profile/views/profile.dart';
import 'package:hive/modules/dashboard_search/views/search.dart';

part '../widgets/index_stack_with_fade_animation.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final ValueNotifier<int> _index = ValueNotifier<int>(0);
  List<Widget> _views = [];

  @override
  void initState() {
    _views = [
      const Home(),
      const Chat(),
      const Search(),
      const Profile(),
    ];
    super.initState();

    MyLogger.printInfo('Dash Board');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
        builder: (BuildContext context, int value, Widget? child) {
          return _IndexStackWithFadeAnimation(
            index: value,
            children: _views,
          );
        },
        valueListenable: _index,
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.white,
        color: Colors.grey.shade500,
        activeColor: const Color(0xffBA68C8),
        style: TabStyle.react,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.chat, title: 'Chat'),
          TabItem(icon: Icons.search, title: 'Search'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: 0,
        onTap: (currentIndex) {
          _index.value = currentIndex;
        },
      ),
    );
  }
}
