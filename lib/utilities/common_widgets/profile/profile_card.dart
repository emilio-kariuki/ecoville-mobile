import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.icon,
    required this.title,
    required this.function,
    required this.showTrailing,
  });
  final String title;
  final Function() function;
  final bool showTrailing;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        function();
      },
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.white,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 20),
          const SizedBox(
            width: 18,
          ),
          AutoSizeText(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          const Spacer(),
          showTrailing
              ? const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 15,
                )
              : const SizedBox.shrink(),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
