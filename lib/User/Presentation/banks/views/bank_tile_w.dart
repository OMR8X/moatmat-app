import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/images_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Features/banks/domain/entites/bank.dart';
import '../../folders/state/cubit/folders_manager_cubit.dart';
import 'banks/pick_bank_v.dart';

class BankTileWidget extends StatelessWidget {
  const BankTileWidget({
    super.key,
    required this.bank,
    required this.onPick,
    this.afterBuy,
  });
  final Bank bank;
  final VoidCallback onPick;
  final VoidCallback? afterBuy;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: SpacingResources.mainWidth(context),
          margin: const EdgeInsets.symmetric(
            vertical: SizesResources.s1,
          ),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: Colors.white24,
                width: 0.5,
              ),
            ),
          ),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                onTap(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SizesResources.s2,
                  horizontal: SizesResources.s2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: SizesResources.s2,
                    ),
                    Image.asset(
                      ImagesResources.testIcon,
                      width: 26,
                      color: ColorsResources.blueText,
                    ),
                    const SizedBox(
                      width: SizesResources.s2,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bank.information.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: ColorsResources.whiteText1,
                          ),
                        ),
                        const SizedBox(height: SizesResources.s1),
                        Text(
                          "${bank.questions.length.toString()} سؤال",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        onTap(context);
                      },
                      child: bank.isPurchased()
                          ? const Text(
                              "فتح",
                              style: TextStyle(fontWeight: FontWeight.bold, color: ColorsResources.whiteText1),
                            )
                          : Text(
                              "${bank.information.price} نقطة",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorsResources.whiteText1,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  onTap(BuildContext context) async {
    if (bank.isPurchased()) {
      showDialog(
        context: context,
        builder: (context) => BuyBankWidget(
          bank: bank,
          onPick: () {
            onPick();
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => BuyBankWidget(
          bank: bank,
        ),
      ).then((value) {
        context.read<FoldersManagerCubit>().refresh();
      });

      if (afterBuy != null) {
        afterBuy!();
      }
    }
  }
}
