import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/consts/consts.dart';
import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/widgets/dialogs/called_from.dart';
import 'package:muzzbirzha_mobile/widgets/dialogs/invest_dialog.dart';
import 'package:transparent_image/transparent_image.dart';

class InvestmentItem extends StatefulWidget {
  const InvestmentItem({
    super.key,
    required this.track,
    required this.goToTrack,
    required this.calledFrom,
  });

  final Track track;
  final Function() goToTrack;
  final CalledFrom calledFrom;

  @override
  State<InvestmentItem> createState() => _InvestmentItemState();
}

class _InvestmentItemState extends State<InvestmentItem> {
  var leftForSale = 0.0;

  double calculateLeftForSale() {
    var investedPercent = 0.0;

    if (widget.track.investments != null && widget.track.finInfo != null) {
      for (var invesnment in widget.track.investments!) {
        investedPercent += invesnment.boughtPercent!;
      }
      return widget.track.finInfo!.percentForSale! - investedPercent;
    }

    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    leftForSale = calculateLeftForSale();

    return Card(
      margin: const EdgeInsets.only(left: mainLeftMargin, bottom: 6),
      clipBehavior: Clip.none,
      child: InkWell(
        onTap: widget.goToTrack,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(widget.track.imageUrl!),
              fit: BoxFit.cover,
              height: 60,
              width: 60,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.track.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.track.artist!.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (widget.track.finInfo != null)
              IconButton(
                onPressed: leftForSale > 0
                    ? () {
                        showInvestDialog(
                          context,
                          widget.track,
                        );
                      }
                    : null,
                icon: const Icon(Icons.monetization_on),
              ),
          ],
        ),
      ),
    );
  }
}
