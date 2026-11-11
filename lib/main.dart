import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase initialisation is added in Phase 5 (Notifications).
  runApp(const ProviderScope(child: TrustMeApp()));
}
