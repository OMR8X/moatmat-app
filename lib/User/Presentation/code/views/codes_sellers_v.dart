import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moatmat_app/User/Core/constant/materials.dart';
import 'package:moatmat_app/User/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_app/User/Presentation/code/state/centers/codes_centers_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/resources/texts_resources.dart';
import '../widgets/code_center_w.dart';

class CodesSellersView extends StatefulWidget {
  const CodesSellersView({super.key});

  @override
  State<CodesSellersView> createState() => _CodesSellersViewState();
}

class _CodesSellersViewState extends State<CodesSellersView> {
  @override
  void initState() {
    context.read<CodesCentersCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppBarTitles.codesSellers),
      ),
      body: BlocBuilder<CodesCentersCubit, CodesCentersState>(
        builder: (context, state) {
          if (state is CodesCentersGovernorates) {
            return GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: SizesResources.s2,
                vertical: SizesResources.s2,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: SizesResources.s2,
                crossAxisSpacing: SizesResources.s2,
              ),
              itemCount: state.governorates.length,
              itemBuilder: (context, index) {
                return GovernorateWidget(
                  governorate: state.governorates[index],
                  onTap: () {
                    context.read<CodesCentersCubit>().exploreGovernorate(
                          state.governorates[index],
                        );
                  },
                );
              },
            );
          } else if (state is CodesCentersExplore) {
            return GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingResources.sidePadding,
                vertical: SizesResources.s2,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: SizesResources.s2,
                crossAxisSpacing: SizesResources.s2,
              ),
              itemCount: state.centers.length,
              itemBuilder: (context, index) {
                return CodeCenterWidget(center: state.centers[index]);
              },
            );
          } else if (state is CodesCentersError) {
            return const Center();
          }
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}

class GovernorateWidget extends StatelessWidget {
  const GovernorateWidget(
      {super.key, required this.governorate, required this.onTap});
  final String governorate;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsResources.onPrimary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: ShadowsResources.mainBoxShadow,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: SizesResources.s4),
                SizedBox(
                  width: SpacingResources.mainHalfWidth(context) / 2,
                  child: Image.asset(getImage(governorate)),
                ),
                //
                const SizedBox(height: SizesResources.s4),
                //
                Text(governorate),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getImage(String s) {
    s = s.replaceAll(" ", "-");
    return "assets/images/governorates/$s.png";
  }
}
