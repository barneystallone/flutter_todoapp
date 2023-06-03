import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todoapp_v1/pages/home_page.dart';
import '../services/local/shared_prefs.dart';
import './auth_textfield_group.dart';
import './custom_button.dart';
import '../models/user_model.dart';

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
  String? _submitErrorMessage;
  final SharedPrefs _prefs = SharedPrefs();

  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  void validateEmail(String value) {
    if (value.isEmpty) {
      setState(() {
        _emailErrorMessage = "Email không được để trống";
      });
    } else if (!EmailValidator.validate(value, true)) {
      setState(() {
        _emailErrorMessage = "Địa chỉ Email không hợp lệ";
      });
    } else {
      setState(() {
        _emailErrorMessage = null;
      });
    }
  }

  void validatePW(String value) {
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
    if (_emailErrorMessage == null && _pwErrorMessage == null) {
      try {
        UserModel user =
            users.where((element) => element.username == email).toList()[0];

        if (user.password != password) {
          return setState(() {
            _submitErrorMessage = 'Sai tên đăng nhập hoặc mật khẩu';
          });
        }
        _prefs.setUsername(user.username as String);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } catch (e) {
        if (e.toString().contains('RangeError')) {
          return setState(() {
            _submitErrorMessage = 'Không tìm thấy tài khoản $email ';
          });
        }
        return setState(() {
          _submitErrorMessage = e.toString();
        });
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
                          _submitErrorMessage as String,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
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
                    CustomButton(
                      title: widget.title,
                      onPressed: handleSubmit,
                    )
                  ],
                ),
              )),
        ]));
  }
}
