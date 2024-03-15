import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/resources/texts_resources.dart';

class CodesSellersView extends StatefulWidget {
  const CodesSellersView({super.key});

  @override
  State<CodesSellersView> createState() => _CodesSellersViewState();
}

class _CodesSellersViewState extends State<CodesSellersView> {
  List<Map> centers = [];
  bool loading = true;

  Future<void> getCenters() async {
    var res = await Supabase.instance.client.from("centers").select();
    centers = res;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getCenters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppBarTitles.codesSellers),
      ),
      body: loading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : GridView.builder(
              padding: const EdgeInsets.only(
                top: SizesResources.s2,
                left: SpacingResources.sidePadding,
                right: SpacingResources.sidePadding,
                bottom: SizesResources.s10 * 2,
              ),
              itemCount: centers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: SizesResources.s2,
                mainAxisSpacing: SizesResources.s2,
              ),
              itemBuilder: (context, index) {
                return Container(
                  width: SpacingResources.mainHalfWidth(context),
                  height: SpacingResources.mainHalfWidth(context),
                  decoration: BoxDecoration(
                    color: ColorsResources.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: ShadowsResources.mainBoxShadow,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: centers[index]["phone"] != null &&
                              (centers[index]["phone"] as String).isNotEmpty
                          ? () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: centers[index]["phone"],
                                ),
                              ).then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("تم نسخ الرقم للحافظة"),
                                  ),
                                );
                              });
                            }
                          : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: SpacingResources.mainHalfWidth(context) / 4,
                            backgroundColor: ColorsResources.background,
                            child:
                                Image.asset("assets/images/home/locations.gif"),
                          ),
                          const SizedBox(height: SizesResources.s2),
                          Text(
                            centers[index]["name"],
                            style: const TextStyle(
                              fontSize: 12,
                              color: ColorsResources.blackText1,
                            ),
                          ),
                          const SizedBox(height: SizesResources.s1),
                          Text(
                            centers[index]["sub_name"],
                            style: const TextStyle(
                              fontSize: 10,
                              color: ColorsResources.blackText2,
                            ),
                          ),
                          if (centers[index]["phone"] != null) ...[
                            const SizedBox(height: SizesResources.s1),
                            Text(
                              centers[index]["phone"],
                              style: const TextStyle(
                                fontSize: 10,
                                color: ColorsResources.blackText2,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
