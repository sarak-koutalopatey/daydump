import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_strings.dart';
import '../services/remote_config_service.dart';
import '../theme/app_colors.dart';
import '../widgets/pressable.dart';
import '../widgets/primary_button.dart';

class UpdateAnnouncementScreen extends StatelessWidget {
  final UpdateInfo info;

  const UpdateAnnouncementScreen({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Scaffold(
      backgroundColor: context.cBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: context.cAccentTint,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.system_update_rounded,
                  color: context.cAccent,
                  size: 40,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                s.updateAvailableTitle,
                style: GoogleFonts.figtree(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: context.cText,
                  letterSpacing: -0.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                s.updateAvailableBody(info.latestVersion),
                style: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: context.cText2,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              if (info.hasUrl)
                PrimaryButton(
                  label: s.updateNow,
                  onTap: () => launchUrl(
                    Uri.parse(info.updateUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
              const SizedBox(height: 16),
              Pressable(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Center(
                    child: Text(
                      s.remindMeLater,
                      style: GoogleFonts.figtree(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: context.cText3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
