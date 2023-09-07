import 'package:flutter/material.dart';
import 'package:hive/Logger/my_logger.dart';
import 'package:hive/constants/sendbird_instance.dart';
import 'package:hive/widgets/circular_avatar_widget.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key, required this.channelUrl});

  final String channelUrl;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with ChannelEventHandler {
  final _messages = <BaseMessage>[];
  TextEditingController _messageController = TextEditingController();

  PreviousMessageListQuery? query;

  late final ChannelEventHandler _channelHandler;

  @override
  void initState() {
    super.initState();

    query = PreviousMessageListQuery(
      channelType: ChannelType.group,
      channelUrl: widget.channelUrl,
    )..messageTypeFilter = MessageTypeFilter.all;
    _fetchLatestMessages();
    _markMessagesAsRead();
  }

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    super.onMessageReceived(channel, message);
    MyLogger.printInfo('NEW MESSAGE IN ${channel.channelUrl}');
    final currentChannelUrl = widget.channelUrl;
    final messageInCurrentChannel = channel.channelUrl == currentChannelUrl;
    if (messageInCurrentChannel) {
      _messages.add(message);
    }

    print('new message');
    print(message);
  }

  @override
  void onChannelChanged(BaseChannel channel) {
    super.onChannelChanged(channel);
    MyLogger.printInfo('CHANGES HAS BEEN MADE IN{channel.channelUrl}');
    final currentChannelUrl = widget.channelUrl;
    final isGroupChannel = channel is GroupChannel;
    final isTheCurrentChannel = channel.channelUrl == currentChannelUrl;

    if (!isGroupChannel || !isTheCurrentChannel) {
      return;
    }

    if (channel.lastMessage == null) {
      return;
    }

    _addNewlySentMessage(channel.lastMessage!);

    print('onChannelChanged');
    print(channel.lastMessage!);
  }

  void _addNewlySentMessage(BaseMessage baseMessage) {
    _messages.add(baseMessage);

    MyLogger.printInfo('_addNewlySentMessage');
  }

  Future<void> _markMessagesAsRead() async {
    try {
      final groupChannel = await GroupChannel.getChannel(widget.channelUrl);
      groupChannel.markAsRead();
      MyLogger.printInfo('MARKED MESSAGES AS READ');
    } catch (error) {
      MyLogger.printError('UNABLE TO MARK MESSAGES DUE TO $error');
    }
  }

  Future<void> _fetchLatestMessages() async {
    try {
      query!.limit = 10;
      final results = await query!.loadNext();
      _messages.addAll(results);
      _messages.sort((a, b) {
        return a.createdAt.compareTo(b.createdAt);
      });

      print('new messages');
      print(results);
    } on Exception catch (e) {
      MyLogger.printError(e);
    } catch (e) {
      MyLogger.printError(e);
    }
  }

  Future<void> _fetchMoreMessages() async {
    try {
      query!.limit = 5;
      final previousMessages = await query!.loadNext();

      _messages.addAll(previousMessages);
      _messages.sort((a, b) {
        return a.createdAt.compareTo(b.createdAt);
      });
    } on Exception catch (e) {
      MyLogger.printError(e);
    } catch (e) {
      MyLogger.printError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.all(20),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final baseMessage = _messages[index];
                switch (baseMessage.runtimeType) {
                  case UserMessage:
                    return getProperMessageTile(baseMessage);
                  case FileMessage:
                    return const Text('File Message');
                  // case AdminMessage:
                  //   return _AdminMessageListTile(baseMessage: baseMessage);
                  default:
                    return const SizedBox();
                }
              },
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              children: [
                SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                SizedBox(width: 15),
                IconButton(
                    onPressed: () {
                      sendTextMessage();
                      _fetchLatestMessages();
                    },
                    icon: Icon(Icons.send)),
                SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendTextMessage() async {
    try {
      final message = _messageController.text.trim();
      final params = UserMessageParams(message: message)
        ..mentionType = MentionType.channel
        ..pushOption = PushNotificationDeliveryOption.normal;

      final channelUrl = widget.channelUrl;
      final groupChannel = await GroupChannel.getChannel(channelUrl);

      groupChannel.sendUserMessage(params, onCompleted: (message, error) {
        if (error != null) {
          MyLogger.printError(error);
          throw Exception('$error');
        } else {
          // Showing of this newly sent message is handled in chat controller.
          print('Message Sent');
          MyLogger.printInfo('Message Sent');
        }
      });
    } on Exception catch (e) {
      MyLogger.printError(e);
    } catch (e) {
      MyLogger.printError(e);
    }
  }
}

getProperMessageTile(BaseMessage baseMessage) {
  final sender = baseMessage.sender!.userId;
  final currentUser = sendBird.currentUser!.userId;
  if (sender == currentUser) {
    return _MyMessageListTile(baseMessage: baseMessage);
  } else {
    return _FriendMessageListTileWidget(baseMessage: baseMessage);
  }
}

class _MyMessageListTile extends StatelessWidget {
  const _MyMessageListTile({
    Key? key,
    required this.baseMessage,
  }) : super(key: key);

  final BaseMessage baseMessage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.blue.withOpacity(0.15),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            baseMessage.message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
          ),
        ),
      ),
      horizontalTitleGap: 10,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircularAvatarWidget(
            imageUrl: baseMessage.sender!.profileUrl.toString(),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class _FriendMessageListTileWidget extends StatelessWidget {
  const _FriendMessageListTileWidget({
    Key? key,
    required this.baseMessage,
  }) : super(key: key);

  final BaseMessage baseMessage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 10,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircularAvatarWidget(
            imageUrl: baseMessage.sender!.profileUrl.toString(),
            color: Colors.blue,
          ),
        ],
      ),
      title: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.blue.withOpacity(0.15),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            baseMessage.message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
          ),
        ),
      ),
    );
  }
}
