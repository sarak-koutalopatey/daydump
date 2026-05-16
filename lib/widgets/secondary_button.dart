import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'pressable.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Widget? leading;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      useBackgroundShift: true,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: context.cSurface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.cBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[
              IconTheme(
                data: IconThemeData(color: context.cText, size: 18),
                child: leading!,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: GoogleFonts.figtree(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.cText,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
