import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/Logger/my_logger.dart';
import 'package:hive/bloc/chat/chat_bloc.dart';
import 'package:hive/constants/sendbird_instance.dart';
import 'package:hive/instances/firebase_instances.dart';
import 'package:hive/widgets/circular_avatar_widget.dart';
import 'package:hive/widgets/dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key, required this.channelUrl});

  final String channelUrl;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with ChannelEventHandler {
  //final _messages = <BaseMessage>[];
  TextEditingController _messageController = TextEditingController();

  final ValueNotifier<List<BaseMessage>> _messages =
      ValueNotifier<List<BaseMessage>>([]);

  PreviousMessageListQuery? query;
  BaseChannel? channel;

  late final ChannelEventHandler _channelHandler;
  final ImagePicker picker = ImagePicker();
  File? file;

  final scrollController = ScrollController();
  double _previousOffset = 0;

  @override
  void initState() {
    super.initState();
    limitMessages = 20;

    BlocProvider.of<ChatBloc>(context).add(
      GetChatEvent(widget.channelUrl),
    );

    _markMessagesAsRead();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        limitMessages += 10;
        BlocProvider.of<ChatBloc>(context).add(
          GetChatEvent(widget.channelUrl),
        );
      } else if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        print("Scrolling up");
      }
    });
    // scrollController.addListener(() {
    //   if (scrollController.offset > _previousOffset) {
    //     // User is scrolling down
    //     print("Scrolling down");
    //   } else if (scrollController.offset < _previousOffset) {
    //     // User is scrolling up
    //     print("Scrolling up");
    //   }

    //   _previousOffset = scrollController.offset;
    // });
  }

  Future<void> _previousMessagesListQuery() async {
    query = PreviousMessageListQuery(
      channelType: ChannelType.group,
      channelUrl: widget.channelUrl,
    )..messageTypeFilter = MessageTypeFilter.all;
  }

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    super.onMessageReceived(channel, message);
    MyLogger.printInfo('NEW MESSAGE IN ${channel.channelUrl}');
    final currentChannelUrl = widget.channelUrl;
    final messageInCurrentChannel = channel.channelUrl == currentChannelUrl;
    if (messageInCurrentChannel) {
      _messages.value.add(message);
    }
  }

  @override
  void onChannelChanged(BaseChannel channel) {
    super.onChannelChanged(channel);
    MyLogger.printInfo('CHANGES HAS BEEN MADE IN{channel.channelUrl');
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
  }

  void _addNewlySentMessage(BaseMessage baseMessage) {
    _messages.value.add(baseMessage);

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

  Future<void> _fetchMoreMessages() async {
    try {
      query!.limit = 5;
      final previousMessages = await query!.loadNext();

      _messages.value.addAll(previousMessages);
      _messages.value.sort((a, b) {
        return a.createdAt.compareTo(b.createdAt);
      });
    } on Exception catch (e) {
      MyLogger.printError(e);
    } catch (e) {
      MyLogger.printError(e);
    }
  }

  Future<void> scrollToBottom() async {
    try {
      if (scrollController.hasClients) {
        // Removing this delay will cause the auto scroll to not work properly.
        // This ensures that we auto scroll all the way down.
        await Future.delayed(const Duration(milliseconds: 100));
        final end = scrollController.position.maxScrollExtent;
        const curve = Curves.easeIn;
        const duration = Duration(milliseconds: 300);
        scrollController.animateTo(end, curve: curve, duration: duration);
      }
      MyLogger.printInfo('AUTO SCROLL TO END OF THE LIST');
    } catch (error) {
      MyLogger.printError(error);
    }
  }

  List<ChatMessage> asDashChatMessages(List<BaseMessage> messages) {
    // BaseMessage is a Sendbird class
    // ChatMessage is a DashChat class
    List<ChatMessage> result = [];

    if (messages.isNotEmpty) {
      messages.forEach((message) {
        User user = message.sender!;
        if (user.nickname.isEmpty) {
          return;
        }
        if (message is FileMessage) {
          print('filemessage');
          result.add(ChatMessage(
              user: asDashChatUser(user),
              createdAt: DateTime.fromMillisecondsSinceEpoch(message.createdAt),
              medias: <ChatMedia>[
                ChatMedia(
                  url: (message as FileMessage).secureUrl.toString(),
                  type: MediaType.image,
                  fileName: 'image.png',
                  isUploading: false,
                ),
              ]));
        } else {
          print('filemessages');
          result.add(
            ChatMessage(
              createdAt: DateTime.fromMillisecondsSinceEpoch(message.createdAt),
              text: messages is FileMessage
                  ? (messages as FileMessage).secureUrl.toString()
                  : message.message,
              user: asDashChatUser(user),
            ),
          );
        }
      });
    }
    result.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return result;
  }

  ChatUser asDashChatUser(User user) {
    return ChatUser(
      firstName: user.nickname,
      id: user.userId,
      profileImage: user.profileUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          BlocConsumer<ChatBloc, ChatState>(
            listenWhen: (context, state) {
              return state.status == ChatStatus.FETCHED;
            },
            listener: (context, state) {
              if (state.status == ChatStatus.FETCHED) {
              } else if (state.status == ChatStatus.ERROR) {}
            },
            buildWhen: (context, state) {
              return state.status == ChatStatus.FETCHED;
            },
            builder: (context, state) {
              ChatUser user = asDashChatUser(sendBird.currentUser!);
              if (state.status == ChatStatus.FETCHED) {
                //scrollToBottom();

                return Expanded(
                  child: DashChat(
                    //typingUsers: [user],
                    key: Key(widget.channelUrl),
                    currentUser: user,
                    quickReplyOptions: QuickReplyOptions(
                        onTapQuickReply: (QuickReply r) async {
                      final ChatMessage message = ChatMessage(
                        user: user,
                        text: r.value ?? r.title,
                        createdAt: DateTime.now(),
                        quickReplies: <QuickReply>[
                          QuickReply(title: 'Great!'),
                          QuickReply(title: 'Awesome'),
                        ],
                      );
                      await sendTextMessage(message.text.trim());
                      BlocProvider.of<ChatBloc>(context).add(
                        GetChatEvent(widget.channelUrl),
                      );
                    }),
                    onSend: (ChatMessage message) async {
                      if (file != null) {
                        await sendFileMessage();

                        // channel!.sendFileMessage(
                        //   FileMessageParams.withFile(file!, name: "Example"),
                        //   onCompleted: (message, error) => {
                        //     file = null,
                        //   },
                        // );
                      } else {
                        await sendTextMessage(message.text.trim());
                        BlocProvider.of<ChatBloc>(context).add(
                          GetChatEvent(widget.channelUrl),
                        );

                        _messageController.clear();
                      }
                    },
                    messages: asDashChatMessages(state.baseMessages!),
                    inputOptions: InputOptions(
                      leading: [
                        IconButton(
                            onPressed: () async {
                              try {
                                final _file = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (_file == null) {
                                  throw Exception('File not chosen');
                                }
                                file = File(_file.path);
                              } catch (e) {
                                throw Exception('File Message Send Failed');
                              }
                            },
                            icon: const Icon(Icons.photo)),
                        IconButton(
                            onPressed: () async {
                              try {
                                final _file = await picker.pickVideo(
                                    source: ImageSource.gallery);
                                if (_file == null) {
                                  throw Exception('File not chosen');
                                }
                                file = File(_file.path);
                              } catch (e) {
                                throw Exception('File Message Send Failed');
                              }
                            },
                            icon: const Icon(Icons.camera)),
                      ],
                      alwaysShowSend: true,
                      textInputAction: TextInputAction.send,
                      inputDecoration: const InputDecoration.collapsed(
                          hintText: "Type a message here..."),
                      sendOnEnter: true,
                    ),
                    messageListOptions: MessageListOptions(
                      dateSeparatorFormat: DateFormat('MMM. dd E h:mm a'),
                      chatFooterBuilder: const SizedBox(
                        height: 10,
                      ),
                      scrollController: scrollController,
                      // onLoadEarlier: () async {
                      //   await Future.delayed(const Duration(seconds: 3));
                      // },
                    ),
                    messageOptions: MessageOptions(
                        onPressAvatar: (val) {},
                        onPressMessage: (val) {},
                        // bottom: (message, previousMessage, nextMessage) {
                        //   return const Icon(
                        //     Icons.check,
                        //     size: 10,
                        //   );
                        // },
                        // showTime: true,
                        timeFormat: DateFormat('h:mm a'),
                        timeTextColor: Colors.black,
                        textColor: Colors.black,
                        currentUserContainerColor: Colors.blue,
                        containerColor: Colors.grey.shade300,
                        showCurrentUserAvatar: false,
                        messagePadding: const EdgeInsets.all(12)),
                  ),
                );
                // return Expanded(
                //   child: ListView.separated(
                //     controller: scrollController,
                //     physics: const AlwaysScrollableScrollPhysics(
                //       parent: BouncingScrollPhysics(),
                //     ),
                //     padding: const EdgeInsets.all(20),
                //     separatorBuilder: (context, index) =>
                //         const SizedBox(height: 10),
                //     itemCount: state.baseMessages!.length,
                //     itemBuilder: (context, index) {
                //       final baseMessage = state.baseMessages![index];

                //       switch (baseMessage.runtimeType) {
                //         case UserMessage:
                //           return getProperMessageTile(baseMessage);
                //         case FileMessage:
                //           return getProperMessageTile(baseMessage);

                //         default:
                //           return const SizedBox();
                //       }
                //     },
                //   ),
                // );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          // Container(
          //   color: Colors.white,
          //   child: Row(
          //     children: [
          //       IconButton(
          //         onPressed: () => dialogComponent(
          //           context,
          //           title: 'File Upload',
          //           content: 'Choose type to upload',
          //           buttonText1: 'Image',
          //           onTap1: () async {
          //             try {
          //               final _file =
          //                   await picker.pickImage(source: ImageSource.gallery);
          //               if (_file == null) {
          //                 throw Exception('File not chosen');
          //               }
          //               file = File(_file.path);
          //             } catch (e) {
          //               throw Exception('File Message Send Failed');
          //             }

          //             setState(() {});
          //           },
          //           buttonText2: 'Video',
          //           onTap2: () async {
          //             try {
          //               final _file =
          //                   await picker.pickVideo(source: ImageSource.gallery);
          //               if (_file == null) {
          //                 throw Exception('File not chosen');
          //               }
          //               file = File(_file.path);
          //             } catch (e) {
          //               throw Exception('File Message Send Failed');
          //             }

          //             setState(() {});
          //           },
          //         ),
          //         icon: const Icon(Icons.add),
          //       ),
          //       SizedBox(width: 20),
          //       Expanded(
          //         child: TextField(
          //           controller: _messageController,
          //           decoration: InputDecoration(
          //             hintText: 'Type your message...',
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: 15),
          //       IconButton(
          //           onPressed: () async {
          //             if (file != null) {
          //               await sendFileMessage();

          //               // channel!.sendFileMessage(
          //               //   FileMessageParams.withFile(file!, name: "Example"),
          //               //   onCompleted: (message, error) => {
          //               //     file = null,
          //               //   },
          //               // );
          //             } else {
          //               // await sendTextMessage();
          //               // BlocProvider.of<ChatBloc>(context).add(
          //               //   GetChatEvent(widget.channelUrl),
          //               // );

          //               // _messageController.clear();
          //             }
          //           },
          //           icon: Icon(Icons.send)),
          //       SizedBox(width: 20),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<void> sendFileMessage() async {
    try {
      final params = FileMessageParams.withFile(file!, name: "Example")
        ..mentionType = MentionType.channel
        ..thumbnailSizes = [const Size(100, 100), const Size(200, 200)];

      final channelUrl = widget.channelUrl;
      final groupChannel = await GroupChannel.getChannel(channelUrl);

      groupChannel.sendFileMessage(params, onCompleted: (message, error) {
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

  Future<void> sendTextMessage(message) async {
    try {
      //final message = _messageController.text.trim();
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
      title: baseMessage is FileMessage
          ? CachedNetworkImage(
              height: 120,
              width: 120,
              fit: BoxFit.contain,
              imageUrl: (baseMessage as FileMessage).secureUrl.toString(),
              placeholder: (context, url) => const SizedBox(
                width: 30,
                height: 30,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )
          : Container(
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
                // child: Text(
                //   baseMessage.message,
                //   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                //         fontSize: 14,
                //         fontWeight: FontWeight.w400,
                //         height: 1.5,
                //       ),
                // ),
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
          child: baseMessage.message is FileMessage
              ? CachedNetworkImage(
                  height: 120,
                  width: 180,
                  fit: BoxFit.cover,
                  imageUrl: (baseMessage.message as FileMessage).secureUrl ??
                      (baseMessage.message as FileMessage).url,
                  placeholder: (context, url) => const SizedBox(
                    width: 30,
                    height: 30,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : Text(
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
