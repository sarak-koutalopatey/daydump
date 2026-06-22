import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class UpdateInfo {
  final bool available;
  final String latestVersion;
  final String updateUrl;

  const UpdateInfo({
    required this.available,
    required this.latestVersion,
    required this.updateUrl,
  });

  bool get hasUrl => updateUrl.isNotEmpty;
}

class RemoteConfigService {
  static final _rc = FirebaseRemoteConfig.instance;

  static Future<void> init() async {
    await _rc.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await _rc.setDefaults(const {
      'update_available': false,
      'latest_version': '1.0.0',
      'update_url_ios': '',
      'update_url_android': '',
    });
    try {
      await _rc.fetchAndActivate();
    } catch (_) {
      // Silently use cached / default values if fetch fails (e.g. no network).
    }
  }

  static UpdateInfo get updateInfo {
    final url = Platform.isIOS
        ? _rc.getString('update_url_ios')
        : _rc.getString('update_url_android');
    return UpdateInfo(
      available: _rc.getBool('update_available'),
      latestVersion: _rc.getString('latest_version'),
      updateUrl: url,
    );
  }
}
