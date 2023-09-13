import 'package:hive/Logger/my_logger.dart';
import 'package:hive/instances/firebase_instances.dart';
import 'package:sendbird_sdk/constant/enums.dart';
import 'package:sendbird_sdk/core/channel/base/base_channel.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/params/message_list_params.dart';
import 'package:sendbird_sdk/query/message_list/previous_message_list_query.dart';
import 'package:sendbird_sdk/utils/extensions.dart';

class ChatRepository {
  static Future<List<BaseMessage>> getMessagesListQuery(
      String channelUrl) async {
    PreviousMessageListQuery query = PreviousMessageListQuery(
      channelType: ChannelType.group,
      channelUrl: channelUrl,
    )..messageTypeFilter = MessageTypeFilter.all;

    final _messages = <BaseMessage>[];

    try {
      // query.limit = 10;
      // final results = await query.loadNext();

      final params = MessageListParams()
        ..isInclusive = true
        ..previousResultSize = limitMessages
        ..nextResultSize = 10;

      final groupChannel = await GroupChannel.getChannel(channelUrl);

      var results = await groupChannel.getMessagesByTimestamp(
        ExtendedInteger.max,
        params,
      );

      _messages.addAll(results);

      _messages.sort((a, b) {
        return a.createdAt.compareTo(b.createdAt);
      });
      return _messages;
    } on Exception catch (e) {
      MyLogger.printError(e);
      return [];
    } catch (e) {
      MyLogger.printError(e);
      return [];
    }
  }
}
