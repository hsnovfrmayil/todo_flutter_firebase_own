import 'package:flutter_riverpod/flutter_riverpod.dart';

final whoState = StateProvider<String>(
  (ref) {
    return "Who";
  },
);
