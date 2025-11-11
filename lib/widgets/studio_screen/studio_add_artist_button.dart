import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';

class StudioAddArtistButton extends StatelessWidget {
  final VoidCallback onTap;
  const StudioAddArtistButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hsl = HSLColor.fromColor(scheme.primary);
    final darker = hsl.withLightness((hsl.lightness * 0.85).clamp(0.0, 1.0)).toColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: MuzzTheme.fabHPad, vertical: MuzzTheme.fabVPad),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [scheme.primary, darker]),
          borderRadius: BorderRadius.circular(MuzzTheme.cornerRadiusLarge),
          boxShadow: const [BoxShadow(blurRadius: 16, offset: Offset(0, 6), color: MuzzTheme.shadowColorStrong)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 22, color: scheme.onPrimary),
            const SizedBox(width: 8),
            Text('Add Artist', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: scheme.onPrimary)),
          ],
        ),
      ),
    );
  }
}
