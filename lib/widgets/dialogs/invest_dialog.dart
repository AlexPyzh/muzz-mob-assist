import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/investment.dart';
import 'package:muzzbirzha_mobile/models/track.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';
import 'package:muzzbirzha_mobile/providers/auth_provider.dart';
import 'package:muzzbirzha_mobile/providers/invest_provider.dart';
import 'package:muzzbirzha_mobile/widgets/dialogs/called_from.dart';
import 'package:muzzbirzha_mobile/widgets/dialogs/invest_dialog_content.dart';
import 'package:muzzbirzha_mobile/widgets/global_using_widgets.dart';

final ValueNotifier<bool> enableInvestButton = ValueNotifier(false);

void canInvest(bool canInvest) {
  enableInvestButton.value = canInvest;
}

Future invest(Investment investment) async {
  await MuzzClient().investInTrack(investment);
}

Future<void> showInvestDialog(
  BuildContext context,
  Track track,
) {
  var authProvider = Provider.of<AuthProvider>(context, listen: false);
  var investProvider = Provider.of<InvestProvider>(context, listen: false);
  TextEditingController percentController = TextEditingController();
  TextEditingController dollarController = TextEditingController();
  investProvider.track = track;

  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          "Invest and earn with ${track.name}",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
        ),
        content: InvestDialogContent(
          percentController: percentController,
          dollarController: dollarController,
          track: track,
          canInvest: canInvest,
        ),
        actions: <Widget>[
          ValueListenableBuilder<bool>(
            valueListenable: enableInvestButton,
            builder: (context, value, child) => TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: value
                  ? () async {
                      var investment = Investment(
                        userId: authProvider.loggedInUser.id,
                        trackId: track.id,
                        boughtPercent:
                            double.parse(percentController.text.trim()),
                      );

                      await invest(investment);
                      investProvider.investments = await MuzzClient()
                          .getUnitedUserInvestments(
                              authProvider.loggedInUser.id!);

                      percentController.dispose();
                      dollarController.dispose();
                      Navigator.of(context).pop();
                    }
                  : null,
              child: const Text('Invest now'),
            ),
          ),
        ],
      );
    },
  );
}
