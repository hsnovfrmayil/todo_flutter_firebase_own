import 'package:data_statement/model/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageNotifier extends StateNotifier<List<Message>> {
  MessageNotifier() : super([]);
  void addTodo(Message message) {
    state = [...state, message];
  }

  void removeMessage(String message) {
    state = [
      for (final mes in state)
        if (mes.message != message) mes,
    ];
  }
}
