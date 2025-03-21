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

final TextStyle loginButtonTextStyle=GoogleFonts.montserrat(
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamilyFallback: ['Arial'],
    )
);

final TextStyle navigationBarDestinationTextStyle=GoogleFonts.outfit(
    textStyle: const TextStyle(
        color: Colors.blue,
        fontSize: 20,
        fontWeight: FontWeight.bold
    )
);


final TextStyle deviceCardIdTextStyle=GoogleFonts.josefinSans(
    textStyle: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w400,
        color: Colors.white
    )
);

final TextStyle deviceCardNameTextStyle=GoogleFonts.ibmPlexMono(
    textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: Colors.white
    )
);

final TextStyle deviceListTitleTextStyle=GoogleFonts.robotoMono(
    textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15
    )
);

final TextStyle deviceDetailTitleTextStyle=GoogleFonts.robotoMono(
    textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 15
    )
);

final TextStyle bottomPartialTabClientDetailTextStyle=GoogleFonts.teko(
    textStyle:TextStyle(
        fontSize: 30,
        color: Colors.black,
        fontWeight: FontWeight.bold
    )
);

final TextStyle deviceValueDeviceDetailTextStyle=GoogleFonts.sourceCodePro(
    textStyle:TextStyle(
        fontSize: 18,
        color: Colors.cyan,
        fontWeight: FontWeight.normal
    )
);

final TextStyle timeUnitDropDownListLetterTextStyle=GoogleFonts.sixtyfour(
    textStyle:TextStyle(
        color: Colors.white,
        fontSize: 30
    )
);

final TextStyle timeUnitDropDownListTextStyle=GoogleFonts.montserrat(
    textStyle:TextStyle(
        color: Colors.white,
        fontSize: 20
    )
);

final TextStyle dataOptionMobileTextStyle=GoogleFonts.montserrat(
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamilyFallback: ['Arial'],
    )
);

final TextStyle customCheckerTitleTextStyle=GoogleFonts.robotoMono(
    textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15
    )
);

final TextStyle customCheckerValueTextStyle=GoogleFonts.ibmPlexMono(
    textStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        color: Colors.black
    )
);
