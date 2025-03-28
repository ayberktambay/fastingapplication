import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PrayerTimeCard extends StatelessWidget {
  final String prayerName;
  final String time;
  final bool isNext;
  final Color color;

  const PrayerTimeCard({
    Key? key,
    required this.prayerName,
    required this.time,
    required this.isNext,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isNext ? color.withOpacity(0.2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              prayerName,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                color: isNext ? color : Colors.black87,
              ),
            ),
            Text(
              time,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                color: isNext ? color : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .slideX(begin: 0.2, end: 0);
  }
} 