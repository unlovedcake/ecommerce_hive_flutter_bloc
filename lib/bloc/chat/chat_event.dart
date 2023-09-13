part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetChatEvent extends ChatEvent {
  final String channelUrl;
  GetChatEvent(this.channelUrl);
}
