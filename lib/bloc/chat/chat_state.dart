part of 'chat_bloc.dart';

enum ChatStatus { INITIAL, FETCHING, FETCHED, ERROR }

@immutable
class ChatState extends Equatable {
  final ChatStatus status;
  final String? error;
  final List<BaseMessage>? baseMessages;

  const ChatState({required this.status, this.error, this.baseMessages});

  factory ChatState.initial() {
    return const ChatState(status: ChatStatus.INITIAL);
  }

  ChatState copyWith({
    required ChatStatus status,
    String? error,
    List<BaseMessage>? baseMessagess,
  }) {
    return ChatState(status: status, error: error, baseMessages: baseMessagess);
  }

  @override
  List<Object?> get props => [status, error, baseMessages];
}
