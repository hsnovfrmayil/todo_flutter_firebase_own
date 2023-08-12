import 'package:data_statement/model/message_model.dart';
import 'package:data_statement/services/message_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageProvider = StateNotifierProvider<MessageNotifier, List<Message>>(
  (ref) {
    return MessageNotifier();
  },
);
