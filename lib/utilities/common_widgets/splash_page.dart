import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../views/bottom_bar/home.dart';
import '../app_images.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Future.delayed(const Duration(seconds: 2), () async {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => const Home())));
    });
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 30),
        width: double.infinity,
        color: Colors.white,
        child: const Center(
            child: Center(
          child: SizedBox(
              height: 30,
              width: 30,
              child: SpinKitFadingCircle(
                color: Colors.black,
                size: 30,
              )),
        )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: SvgPicture.asset(
              AppImages.register,
              height: height * 0.15,
              width: width * 0.5,
            )),
            const SizedBox(
              height: 20,
            ),
             AutoSizeText(
                        "Ecoville",
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff000000),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
