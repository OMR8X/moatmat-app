import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Presentation/home/view/my_qr_code_view.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../state/auth_c/auth_cubit_cubit.dart';

class OfflineView extends StatefulWidget {
  const OfflineView({super.key});

  @override
  State<OfflineView> createState() => _OfflineViewState();
}

class _OfflineViewState extends State<OfflineView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("غير متصل بالانترنت"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().init();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          //
          SizedBox(height: SizesResources.s6),
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: SpacingResources.mainWidth(context),
                decoration: BoxDecoration(
                  color: ColorsResources.primary.withAlpha(50),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: ColorsResources.darkPrimary,
                    width: 2,
                  ),
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MyQrCodeView(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            "رمز الحضور",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorsResources.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: SizesResources.s3),
                        Icon(
                          Icons.qr_code,
                          size: 26,
                          color: ColorsResources.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
