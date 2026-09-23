import 'package:flutter/material.dart';
import 'package:secure_home/l10n/generated/app_localizations.dart';

/// Shortcut for reading the localized messages of the current context.
extension ContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
