import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RowButton extends StatelessWidget {
  const RowButton({
    super.key,
    required this.width,
    required this.title,
    required this.icon,
    required this.function,
    required this.iconColor,
  });

  final double width;
  final String title;
  final IconData icon;
  final Color iconColor;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        radius: 10,
        splashColor: Colors.grey[300],
        onTap: function,
        child: SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 25,
              ),
              SizedBox(
                width: width * 0.02,
              ),
              Text(
                title,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
