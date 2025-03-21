import 'dart:convert';

import 'package:fe/Base/ChosenTextStyle.dart';
import 'package:fe/Base/FormatedTextField.dart';
import 'package:fe/Base/ImageButton.dart';
import 'package:fe/Models/Stupid_Token.dart';
import 'package:fe/Models/Stupid_User.dart';
import 'package:fe/Providers/registerProviders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class LoginScreen extends ConsumerWidget
{
  const LoginScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
        (ref.watch(loginController).isRegister)?"Register":"Login",
          style: GoogleFonts.montserrat(
            textStyle:const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              fontFamilyFallback: ['Arial'],

            )
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: LayoutBuilder(
        builder: (context,constraints) {
          return () {
            double w = constraints.maxWidth, h = constraints.maxHeight;
            double rw = mobileWidth, rh = mobileHeight;
            // print(h.toString());
            // if (h<630)
            //   return Center(
            //     child: Icon(
            //       CupertinoIcons.xmark_circle,
            //       color: Colors.red,
            //       size: 50,
            //     ),
            //   );
            if (rw >= w) {
              return _mobileLoginScreen(window_height: h,window_width: w,);
            }
            return _desktopLoginScreen(window_height: h,window_width: w,);
            // return w.toString()+"   "+h.toString();
          }();
        }
      ),
    );
  }

}

class _mobileLoginScreen extends ConsumerWidget
{
  final double window_width;
  final double window_height;


  const _mobileLoginScreen({required this.window_width,required this.window_height});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Opacity(
            opacity: 0.8,
            child: Image.network(
                "https://st2.depositphotos.com/2171279/12229/i/950/depositphotos_122292012-stock-illustration-hand-draw-doodle-elements.jpg",
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),
        ),
        Row(
          children: [
            const Expanded(
                flex: 2,
                child: Column()
            ),
            Expanded(
                flex: 3,
                child: _loginBox(
                    width: window_width*3/5,
                    height: window_height,
                    isMobile: true,
                )
            )
          ],
        )
      ],
    );
  }
  
}
class _desktopLoginScreen extends ConsumerWidget
{
  final double window_width;
  final double window_height;


  const _desktopLoginScreen({required this.window_width,required this.window_height});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Opacity(
            opacity: 0.9,
            child: Image.network(
              "https://i.redd.it/ichgvpyuwpe61.jpg",
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.4),
              colorBlendMode: BlendMode.darken,
            ),
          ),
        ),
        Center(
          child: _loginBox(
            height: window_height*4/5,
            width: window_width*3/5,
            isMobile: false,
          ),
        )
      ],
    );
  }
}

class _loginBox extends ConsumerWidget
{
  final double width;
  final double height;
  final bool isMobile;

  const _loginBox({required this.width,required this.height,required this.isMobile,});

  Future<Response> register_user(Stupid_User user) async
  {
    return await stupidRoomAPI.registerApi(user);
  }

  Future<Response> user_login(Stupid_User user)async
  {
    return await stupidRoomAPI.loginApi(user);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: (!isMobile) ? BorderRadius.circular(20) : const BorderRadius
              .only(
              bottomLeft: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: const Offset(3, 3),
                spreadRadius: 5,
                blurRadius: 5
            )
          ]
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 30),
        child: Container(
          // color: Colors.red,
          child: Center(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child:(!ref.watch(loginController).isRegister)?
                    _loginForm(
                        parentWidth: width,
                        parentHeight: height,
                        isMobile: isMobile,
                        registerCallBack: (){
                          ref.read(loginController).reset();
                          ref.read(loginController).isRegister=true;
                        },
                        loginCallBack: user_login
                    ):
                    _registerForm(
                        parentWidth: width,
                        parentHeight: height,
                        isMobile: isMobile,
                        registerCallBack: register_user
                    )
              ),
            ),
          ),
        ),
      ),
    );
  }

}

class _registerForm extends ConsumerWidget
{
  final double parentWidth;
  final double parentHeight;
  final bool isMobile;
  final Function(Stupid_User user) registerCallBack;


  const _registerForm(
      {required this.parentWidth,required this.parentHeight,required this.isMobile,required this.registerCallBack});

  Future<void> _register(WidgetRef ref) async{
    String username=ref.watch(loginController).register_username_controller.text;
    String password=ref.watch(loginController).register_password_controller.text;
    String password2=ref.watch(loginController).register_password2_controller.text;
    if(username!="" && password!="" && password2!="") {
      if (password == password2) {
        Response result =
            await registerCallBack(Stupid_User(username, password));
        if (result.statusCode == 200) {
          ref.read(loginController).reset();
        } else {
          Map<String, dynamic> msg =
              jsonDecode(result.body) as Map<String, dynamic>;
          ref.read(loginController).error_message = msg["detail"] as String;
        }
      } else {
        ref.read(loginController).error_message = "Passwords much matched !";
      }
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: (isMobile) ? parentWidth*9/10 : parentWidth*2/3,
          // color: Colors.red,
          child: Text(
            (isMobile)?"STUPID\nROOM":"STUPID ROOM",
            style: GoogleFonts.sixtyfour(
              textStyle:TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: (isMobile)? 38:42,
                color: Colors.blueGrey,
                fontFamilyFallback: const ['Arial'],
              ),
            ),
            textAlign: (!isMobile)?TextAlign.center:TextAlign.start,
          ),
        ),
        _spacing_textField(
          label: "Username",
          controller: ref
              .watch(loginController)
              .register_username_controller,
          isMobile: isMobile,
          parentWidth: parentWidth,
          isPassword: false,
          onSubmitted: ()async
          {
            await _register(ref);
          },
        ),
        _spacing_textField(
          label: "Password",
          controller: ref
              .watch(loginController)
              .register_password_controller,
          isMobile: isMobile,
          parentWidth: parentWidth,
          isPassword: true,
          onSubmitted: ()async
          {
            await _register(ref);
          },
        ),
        _spacing_textField(
          label: "Re-enter Password",
          controller: ref
              .watch(loginController)
              .register_password2_controller,
          isMobile: isMobile,
          parentWidth: parentWidth,
          isPassword: true,
          onSubmitted: ()async
          {
            await _register(ref);
          },
        ),
        _errorTextNotification(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                    onPressed: (){
                      ref.read(loginController).reset();
                    },
                    icon: const Icon
                      (
                      CupertinoIcons.back,
                      color: Colors.black,
                    )
                ),
              ),
              _loginButton(
                  onTap: () async
                  {
                    await _register(ref);
                  },
                  color: Colors.greenAccent,
                  data: "Sign Up",
                  icon: const Icon(
                    Icons.create_outlined,
                    color: Colors.black,
                    size: 30,
                  )
              ),
            ],
          ),
        ),
      ],
    );
  }
  
}

class _errorTextNotification extends ConsumerWidget
{
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
      visible: ref.watch(loginController).error_message!=null,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 20,
              ),
            ),
            Text(
              ref.watch(loginController).error_message??"",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.red,
                fontFamilyFallback: ['Arial'],
              ),
            )
          ],
        ),
      ),
    );
  }

}

class _loginForm extends ConsumerWidget
{
  final double parentWidth;
  final double parentHeight;
  final bool isMobile;
  final Function registerCallBack;
  final Function(Stupid_User user) loginCallBack;


  const _loginForm(
      {required this.parentWidth,required this.parentHeight,required this.isMobile,required this.registerCallBack,required this.loginCallBack});


  Future<void> _login(WidgetRef ref) async{
    String username=ref.watch(loginController).username_controller.text;
    String password=ref.watch(loginController).password_controller.text;
    if(username!="" && password!="") {
      Response result = await loginCallBack(Stupid_User(username, password));
      // print(result.body);
      if (result.statusCode == 200) {
        ref.read(loginController).userToken = StupidToken.fromJson(result.body);
        // print(ref.watch(loginController).userToken?.accessToken);
        ref.read(loginController).needLogin = false;
      }
      else
        {
          ref.read(loginController).error_message=jsonDecode(result.body)["detail"]??"Login Failed";
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: (() {
        // if (isMobile)
        //   return MainAxisAlignment.start;
        return MainAxisAlignment.center;
      })(),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: (isMobile) ? parentWidth*9/10 : parentWidth*2/3,
          // color: Colors.red,
          child: Text(
            (isMobile)?"STUPID\nROOM":"STUPID ROOM",
            style: GoogleFonts.sixtyfour(
              textStyle:TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: (isMobile)? 38:42,
                color: Colors.blueGrey,
                fontFamilyFallback: const ['Arial'],
              ),
            ),
            textAlign: (!isMobile)?TextAlign.center:TextAlign.start,
          ),
        ),
        _spacing_textField(
          label: "Username",
          controller: ref
              .watch(loginController)
              .username_controller,
          isMobile: isMobile,
          parentWidth: parentWidth,
          isPassword: false,
          onSubmitted: () async
          {
            await _login(ref);
          },
        ),
        _spacing_textField(
          label: "Password",
          controller: ref
              .watch(loginController)
              .password_controller,
          isMobile: isMobile,
          parentWidth: parentWidth,
          isPassword: true,
          onSubmitted: () async
          {
            await _login(ref);
          },
        ),
        SizedBox(
          width: (isMobile) ? parentWidth*9/10 : parentWidth*3/5,
          // color: Colors.red,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: (!isMobile) ? CrossAxisAlignment.end : CrossAxisAlignment.center,
              children: [
                _errorTextNotification(),
                _loginButton(
                    onTap:() async
                    {
                      await _login(ref);
                    },
                    data: "Login",
                    color: Colors.white,
                    icon: const Icon(
                      Icons.login_outlined,
                      color: Colors.black,
                      size: 30,
                    )
                ),
                _loginButton(
                    onTap: ()
                    {
                      registerCallBack();
                    },
                    color: Colors.greenAccent,
                    data: "Sign Up",
                    icon: const Icon(
                      Icons.create_outlined,
                      color: Colors.black,
                      size: 30,
                    )
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

}

class _spacing_textField extends FormatedTextField {

  final bool isMobile;
  final double parentWidth;
  @override
  final bool isPassword;
  const _spacing_textField({
    required super.label,
    required super.controller,
    this.isPassword=false,
    this.isMobile = false,
    this.parentWidth = 0,
    Function? onChanged,
    Function? onSubmitted
  }) : super(
    onChanged: onChanged ?? FormatedTextField.defaultfunc,
    isPassword: isPassword,
    onSubmitted: onSubmitted
  );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
          width: (isMobile) ? parentWidth*9/10 : parentWidth*2/3,
          child:FormatedTextField(
              label: label,
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              isPassword: isPassword,
          )
      ),
    );
  }
}

class _loginButton extends ConsumerWidget
{
  final Function onTap;
  final String data;
  final Widget icon;
  final Color color;

  const _loginButton({required this.onTap, required this.data,required this.icon,this.color=Colors.white});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CustomButton(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 150,
          height: 50,
          color: color,
          child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        data,
                      style: loginButtonTextStyle
                    ),
                  ],
                ),
              ),
              Container(
                child: Expanded(
                  flex: 1,
                  child: Center(child: icon)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}