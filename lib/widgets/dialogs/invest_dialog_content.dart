import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';
import 'package:muzzbirzha_mobile/widgets/dialogs/invest_dialog.dart';
import 'package:muzzbirzha_mobile/widgets/dialogs/invest_text_field.dart';
import 'package:muzzbirzha_mobile/widgets/studio_screen/studio_text_field.dart';

class InvestDialogContent extends StatefulWidget {
  const InvestDialogContent({
    required this.percentController,
    required this.dollarController,
    required this.track,
    required this.canInvest,
    super.key,
  });

  final Track track;
  final TextEditingController percentController;
  final TextEditingController dollarController;
  final void Function(bool) canInvest;

  @override
  State<InvestDialogContent> createState() => _InvestDialogContentState();
}

class _InvestDialogContentState extends State<InvestDialogContent> {
  var leftForSale = 100.0;
  Future<Track>? _trackToInvest;

  Future loadTraToInvest() async {
    _trackToInvest = MuzzClient().getTrackById(widget.track.id!);
  }

  @override
  void initState() {
    loadTraToInvest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Track>(
      future: _trackToInvest,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(),
          );
        } else {
          var investedPercent = 0.0;

          if (snapshot.data!.investments != null) {
            for (var invesnment in snapshot.data!.investments!) {
              investedPercent += invesnment.boughtPercent!;
            }
          }

          if (snapshot.data!.finInfo?.percentForSale != null) {
            leftForSale =
                snapshot.data!.finInfo!.percentForSale! - investedPercent;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Capitalization of '${snapshot.data!.name}' \$${snapshot.data!.finInfo!.price}",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Total for sale ${snapshot.data!.finInfo!.percentForSale}%",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Left for sale $leftForSale%",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  InvestTextField(
                    controller: widget.percentController,
                    hintText: "%",
                    keyboardType: TextInputType.number,
                    width: 180,
                    maxLines: 1,
                    maxAmount: leftForSale,
                    canInvest: widget.canInvest,
                    onChanged: () {
                      var numberPercent =
                          double.tryParse(widget.percentController.text.trim());

                      if (numberPercent != null) {
                        widget.dollarController.text =
                            (widget.track.finInfo!.price! /
                                    100 *
                                    double.parse(
                                        widget.percentController.text.trim()))
                                .toStringAsFixed(2);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "%",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  InvestTextField(
                    controller: widget.dollarController,
                    hintText: "\$",
                    keyboardType: TextInputType.number,
                    width: 180,
                    maxLines: 1,
                    maxAmount:
                        snapshot.data!.finInfo!.price! / 100 * leftForSale,
                    canInvest: widget.canInvest,
                    onChanged: () {
                      var numberDollar =
                          double.tryParse(widget.dollarController.text);

                      if (numberDollar != null) {
                        var onePercentCost =
                            snapshot.data!.finInfo!.price! / 100;
                        widget.percentController.text =
                            (double.parse(widget.dollarController.text) /
                                    onePercentCost)
                                .toStringAsFixed(2);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "\$",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  // @override
  // void dispose() {
  //   widget.percentController.dispose();
  //   widget.dollarController.dispose();
  //   super.dispose();
  // }
}
