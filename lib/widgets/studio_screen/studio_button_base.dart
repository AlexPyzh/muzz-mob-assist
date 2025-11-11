import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';

class StudioButtonBase extends StatelessWidget {
  const StudioButtonBase({
    super.key,
    required this.onPressed,
    required this.caption,
    this.backgroundColor,
    this.textColor,
  });

  final VoidCallback onPressed;
  final String caption;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = backgroundColor ?? scheme.primary;
    final hsl = HSLColor.fromColor(base);
    final darker = hsl.withLightness((hsl.lightness * 0.85).clamp(0.0, 1.0)).toColor();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(MuzzTheme.cornerRadiusLarge),
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [base, darker],
            ),
            borderRadius: BorderRadius.circular(MuzzTheme.cornerRadiusLarge),
            boxShadow: const [
              BoxShadow(blurRadius: 16, offset: Offset(0, 6), color: MuzzTheme.shadowColorStrong),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              caption,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: textColor ?? scheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
