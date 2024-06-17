import 'package:flutter_riverpod/flutter_riverpod.dart';

final whoDataProvider = StateProvider<List<String>>(
  (ref) {
    return [];
  },
);

final userDataProvider = StateProvider<List>(
  (ref) {
    return [];
  },
);
