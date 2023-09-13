import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/repositories/chat_repository.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';

part './chat_event.dart';
part './chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState.initial()) {
    on<GetChatEvent>((event, emit) async {
      emit(state.copyWith(status: ChatStatus.FETCHING));
      try {
        final messages =
            await ChatRepository.getMessagesListQuery(event.channelUrl);

        emit(state.copyWith(
            status: ChatStatus.FETCHED, baseMessagess: messages));
      } catch (e) {
        emit(state.copyWith(status: ChatStatus.ERROR));
      }
    });
  }
}
