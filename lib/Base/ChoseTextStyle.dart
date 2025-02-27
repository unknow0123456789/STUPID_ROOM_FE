import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// final clientCardNameStyle=

TextStyle clientCardNameStyle(BoxConstraints constraints)
{
  return GoogleFonts.pressStart2p(
      textStyle:TextStyle(
        color: Colors.orangeAccent,
        fontWeight: FontWeight.bold,
        fontSize: (constraints.maxWidth/20).clamp(10, 35),
      )
  );
}