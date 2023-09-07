import 'package:flutter/material.dart';
import 'package:hive/Logger/my_logger.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();

    MyLogger.printInfo('Profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffBA68C8),
          title: Text('Profile'),
        ),
        body: Center(child: Text('Profile')));
  }
}
