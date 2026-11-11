import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the user-selected locale; null = follow the device.
/// Persistence is added with the Settings feature (Phase 2/3).
class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() => null;

  void setLocale(Locale? locale) => state = locale;
}

final localeControllerProvider =
    NotifierProvider<LocaleController, Locale?>(LocaleController.new);

const supportedLanguageOptions = <(Locale, String)>[
  (Locale('en'), 'English'),
  (Locale('si'), 'සිංහල'),
  (Locale('ta'), 'தமிழ்'),
];
