import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';

import 'auth/view/auth_views_manager.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'موتمت',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorsResources.primary,
        ),
        useMaterial3: true,
        fontFamily: "Tajawal",
        //
        scaffoldBackgroundColor: ColorsResources.background,

        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w500,
              color: ColorsResources.primary,
              fontFamily: "Tajawal",
            ),
            foregroundColor: ColorsResources.primary,
            backgroundColor: ColorsResources.background),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorsResources.primary,
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: ColorsResources.primary,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: ColorsResources.darkPrimary,
            ),
          ),
        ),
        //
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsResources.primary,
            fixedSize: Size(
              SpacingResources.mainWidth(context),
              50,
            ),
            foregroundColor: ColorsResources.whiteText1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: const BorderSide(
                color: ColorsResources.borders,
                width: 0.5,
              ),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ar"),
      ],
      home: const AuthViewsManager(),
    );
  }
}
