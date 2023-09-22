import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../utilities/app_images.dart';
import '../views/authentication/login_page.dart';
import '../views/authentication/register_page.dart';
import '../views/authentication/reset_password.dart';
import '../views/bottom_bar/home.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const Home());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case '/reset_password':
        return MaterialPageRoute(builder: (_) => ResetPassword());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      final height = MediaQuery.of(context).size.height;
      return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black54),
          ),
          body: SizedBox(
            height: height * 0.9,
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(AppImages.oops, height: height * 0.2),
                Text(
                  "Page not found",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: const Color(0xff666666),
                  ),
                ),
              ],
            )),
          ));
    });
  }
}

class ResourceArguments {
  final String title;
  final String category;

  ResourceArguments({required this.title, required this.category});
}

class ImageArguments {
  final String title;
  final String image;

  ImageArguments({required this.title, required this.image});
}
