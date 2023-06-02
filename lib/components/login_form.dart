import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todoapp_v1/components/auth_textfield_group.dart';
import 'package:todoapp_v1/components/custom_button.dart';
import 'package:todoapp_v1/models/user_model.dart';

import 'auth_header.dart';

class LoginForm extends StatefulWidget {
  final String title;

  const LoginForm({super.key, this.title = 'Login'});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _showPW = false;
  String? _emailErrorMessage;
  String? _pwErrorMessage;
  String _submitErrorMessage = 'a';

  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  validateEmail(String value) {
    if (value.isEmpty) {
      setState(() {
        _emailErrorMessage = "Email không được để trống";
        print(_emailErrorMessage);
      });
    } else if (!EmailValidator.validate(value, true)) {
      setState(() {
        _emailErrorMessage = "Địa chỉ Email không hợp lệ";
        print(_emailErrorMessage);
      });
    } else {
      setState(() {
        _emailErrorMessage = null;
      });
    }
  }

  validatePW(String value) {
    if (value.isEmpty) {
      setState(() {
        _pwErrorMessage = "Password không được để trống";
      });
    } else if (value.length < 4) {
      setState(() {
        _pwErrorMessage = "Password tối thiểu phải có 4 ký tự";
      });
    } else {
      setState(() {
        _pwErrorMessage = null;
      });
    }
  }

  void handleSubmit() {
    String email = emailController.text;
    String password = pwController.text;
    if (email.isEmpty) {
      return validateEmail(email);
    }
    if (password.isEmpty) {
      return validatePW(password);
    }
    if (_emailErrorMessage != null && _pwErrorMessage != null) {
      UserModel user =
          users.where((element) => element.username == email).toList()[0];
      print(user.password);
      if (user == null) {
        setState(() {
          _submitErrorMessage = 'Tài khoản không tồn tại';
        });
        return;
      }

      if (user.password != password) {
        setState(() {
          _submitErrorMessage = 'Sai tên đăng nhập hoặc mật khẩu';
        });
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ListView(shrinkWrap: true, children: [
          Transform.translate(
            offset: const Offset(0, -40),
            child: Container(
              color: HexColor("#fed8c3"),
              child: Image.asset(
                'assets/images/plants.png',
                scale: 1.5,
                width: double.infinity,
              ),
            ),
          ),
          Transform.translate(
              offset: const Offset(0, -70),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(40))),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Header(title: widget.title),
                    if (_submitErrorMessage != null)
                      Center(
                        child: Text(
                          _submitErrorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    AuthTextFieldGroup(
                      text: 'Email',
                      hintText: 'abcd@gmail.com',
                      onChanged: (() {
                        validateEmail(emailController.text);
                      }),
                      errText: _emailErrorMessage,
                      controller: emailController,
                      prefixIcon: const Icon(Icons.mail_outline,
                          color: Color.fromRGBO(150, 150, 150, 1)),
                    ),
                    AuthTextFieldGroup(
                      text: 'Password',
                      hintText: 'Nhập password',
                      controller: pwController,
                      onChanged: (() {
                        validatePW(pwController.text);
                      }),
                      errText: _pwErrorMessage,
                      obscureText: !_showPW,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: !_showPW
                          ? const Icon(Icons.remove_red_eye_outlined)
                          : const Icon(Icons.visibility_off_outlined),
                      toggleShowHide: () {
                        setState(() {
                          _showPW = !_showPW;
                        });
                      },
                    ),
                    InkWell(
                        onTap: () => handleSubmit(),
                        child: CustomButton(title: widget.title))
                  ],
                ),
              )),
          // Transform.translate(
          //   offset: const Offset(0, -50),
          //   child: Container(
          //     color: HexColor("#fed8c3"),
          //     child: Image.asset(
          //       'assets/images/plants.png',
          //       scale: 1.5,
          //       width: double.infinity,
          //     ),
          //   ),
          // ),
        ]));
  }
}
