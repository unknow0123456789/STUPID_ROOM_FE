import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class FormatedTextField extends ConsumerWidget
{
  final String label;
  final TextEditingController controller;
  final Function onChanged;
  final bool isPassword;
  final Function? onSubmitted;
  final Color? fillColor;
  final Color? inputColor;
  final Color? labelColor;


  const FormatedTextField({
    super.key,
    required this.label,
    required this.controller,
    this.onChanged=defaultfunc,
    this.isPassword=false,
    this.onSubmitted,
    this.fillColor,
    this.inputColor,
    this.labelColor
  });

  static void defaultfunc(String value)
  {

  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
        controller: controller,
        textInputAction: (onSubmitted!=null)?TextInputAction.go:null,
        onSubmitted: (value) {
          if(onSubmitted!=null)
            {
              onSubmitted!();
            }
        },
        onChanged: (value)
        {
          onChanged(value);
        },
        decoration: InputDecoration(
          label: Text(
            label,
            style: GoogleFonts.montserrat(
                textStyle:TextStyle(
                    color: (labelColor!=null)?labelColor:Colors.blueGrey,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamilyFallback: ['Arial'],
                )
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 3
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 3
              )
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                  color: Colors.red,
                  width: 3
              )
          ),
          fillColor: (fillColor!=null)?fillColor:Colors.transparent,
          filled: true,
        ),
        style: GoogleFonts.montserrat(
          textStyle:TextStyle(
            color: (inputColor!=null)?inputColor:Colors.blue,
            fontSize: 15,
            fontWeight: (!isPassword) ? FontWeight.w400:FontWeight.bold,
            fontFamilyFallback: const ['Arial'],
          ),
        ),
        obscureText: ((){
          // print(isPassword.toString());
          return isPassword;
        })(),
      obscuringCharacter: "*",
    );
  }

}