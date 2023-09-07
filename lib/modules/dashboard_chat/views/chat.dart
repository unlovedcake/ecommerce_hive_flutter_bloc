import 'package:flutter/material.dart';
import 'package:hive/Logger/my_logger.dart';
import 'package:hive/modules/dashboard_chat/views/chat_room.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/params/group_channel_params.dart';
import 'package:sendbird_sdk/query/channel_list/group_channel_list_query.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String channelUrl = '';
  @override
  void initState() {
    super.initState();

    MyLogger.printInfo('Chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffBA68C8),
          title: Text('Chat'),
        ),
        body: Column(
          children: [
            Center(child: Text('Chat')),
            ElevatedButton(
                onPressed: () {
                  createChannel();
                },
                child: Text('Create Channel')),
          ],
        ));
  }

  Future<void> createChannel() async {
    final sendbirdUserIdList = [
      '1ZiQWezBBiSuqQxRhyTzRHDrLwn1',
      'HZh7U4lx8xYtGy3e3BOCExqJ62r1'
    ];
    final query = GroupChannelListQuery()
      ..userIdsExactlyIn = sendbirdUserIdList;
    final result = await query.loadNext();

    if (result.isNotEmpty) {
      MyLogger.printInfo('CHAT GROUP ALREADY EXIST');
      MyLogger.printInfo('CHANNEL_URL: ${result.first.channelUrl}');
      channelUrl = result.first.channelUrl;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatRoom(channelUrl: channelUrl),
        ),
      );
    }

    final params = GroupChannelParams()
      ..userIds = sendbirdUserIdList
      ..isDistinct = true;
    final newChannel = await GroupChannel.createChannel(params);
    channelUrl = newChannel.channelUrl;

    print('Channel Url');
    print(channelUrl);
  }
}
