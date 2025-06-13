import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';
import 'package:sentinix_ecommerce/UI/Navigation_Bar/navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sentinix Ecommerce',
        theme: ThemeData(
          scaffoldBackgroundColor: appSecondaryColor,
          primaryColor: appPrimaryColor,
          unselectedWidgetColor: appPrimaryColor,
          fontFamily: "Montserrat-Regular",
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: appSecondaryColor,
          ),
        ),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0),
            ),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: child!,
            ),
          );
        },
        home: const DashboardScreen(),
      ),
    );
  }
}
