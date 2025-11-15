import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insectpedia/themes/insectpedia_colors.dart';

class InsectpediaTypography{
  static TextStyle h1 = GoogleFonts.spaceGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: InsectpediaColors.textColor
  );

  static TextStyle h2 = GoogleFonts.spaceGrotesk(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: InsectpediaColors.textColor
  );

  static TextStyle h3 = GoogleFonts.spaceGrotesk(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: InsectpediaColors.textColor
  );

  static TextStyle h4 = GoogleFonts.spaceGrotesk(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: InsectpediaColors.text2Color
  );

  static TextStyle h5 = GoogleFonts.spaceGrotesk(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: InsectpediaColors.textColor
  );

  static TextStyle body = GoogleFonts.spaceGrotesk(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: InsectpediaColors.text2Color,
      height: 1.6
  );

  static TextStyle body2 = GoogleFonts.spaceGrotesk(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: InsectpediaColors.text2Color,
      height: 1.6
  );

  static TextStyle caption = GoogleFonts.spaceGrotesk(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: InsectpediaColors.text2Color,
  );

  static TextStyle captionBold = GoogleFonts.spaceGrotesk(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: InsectpediaColors.text2Color,
  );

  static TextStyle caption2 = GoogleFonts.spaceGrotesk(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: InsectpediaColors.text2Color,
  );

  static TextStyle labelButton = GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: InsectpediaColors.textColor,
  );

  static TextStyle labelTextField = GoogleFonts.spaceGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: InsectpediaColors.text2Color,
  );

  static TextStyle placeholder = GoogleFonts.spaceGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: InsectpediaColors.greyColor,
  );
}
