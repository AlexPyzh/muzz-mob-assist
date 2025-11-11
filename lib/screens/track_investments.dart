import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/models/investment.dart';
import 'package:muzzbirzha_mobile/providers/track_list_provider.dart';
import 'package:muzzbirzha_mobile/consts/paths.dart';

class TrackInvestmentsScreen extends StatelessWidget {
  const TrackInvestmentsScreen({
    super.key,
    required this.track,
    required this.investment,
  });

  final Track track;
  final Investment investment;

  String _fmtCurrency(num? value) {
    final v = (value ?? 0).toDouble();
    final f = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return f.format(v);
  }

  @override
  Widget build(BuildContext context) {
    final fin = track.finInfo;
    final fullPrice = fin?.price ?? 0.0;
    final soldPercent = fin?.soldPercent ?? 0.0;
    final userPercent = investment.boughtPercent ?? 0.0;

    final userAmount = fullPrice * (userPercent / 100.0);
    final soldAmount = fullPrice * (soldPercent / 100.0);

    // Placeholder estimated earnings for current user (to be replaced with real metric)
    final estEarningsPercent = 0.0;
    final estEarningsAmount = 0.0;

    final tlp = Provider.of<TrackListProvider>(context, listen: false);

    void playTrack() {
      // play the single track on tap
      tlp.goToTrack([track], 0, context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(track.name ?? 'Track', overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with cover + title
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: playTrack,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: track.imageUrl != null && (track.imageUrl?.isNotEmpty ?? false)
                        ? Image.network(track.imageUrl!, width: 96, height: 96, fit: BoxFit.cover)
                        : Container(
                            width: 96, height: 96, alignment: Alignment.center,
                            decoration: BoxDecoration(color: const Color(0xFF2A2B2F), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.music_note, size: 32),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: playTrack,
                    child: Text(
                      track.name ?? 'Track',
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Artist chip/avatar row
            if (track.artist != null) GestureDetector(
              onTap: () {
                final id = track.artist!.id;
                if (id != null) {
                  Navigator.of(context).pushNamed(artistScreenPath, arguments: id);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: (track.artist?.imageUrl?.isNotEmpty ?? false)
                        ? NetworkImage(track.artist!.imageUrl!) : null,
                    child: (track.artist?.imageUrl?.isNotEmpty ?? false) ? null : const Icon(Icons.person, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(track.artist?.name ?? '', style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Info table
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Metric')),
                  DataColumn(label: Text('Value')),
                ],
                rows: [
                  DataRow(cells: [
                    const DataCell(Text('Full price')),
                    DataCell(Text(_fmtCurrency(fullPrice))),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Your share / Sold')),
                    DataCell(
                      Text('${userPercent.toStringAsFixed(2)}% (${_fmtCurrency(userAmount)})'
                           ' / ${soldPercent.toStringAsFixed(2)}% (${_fmtCurrency(soldAmount)})'),
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Est. earnings')),
                    DataCell(Text('${estEarningsPercent.toStringAsFixed(2)}% (${_fmtCurrency(estEarningsAmount)})')),
                  ]),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
