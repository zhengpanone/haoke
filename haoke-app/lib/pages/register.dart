import 'package:flutter/material.dart';
import 'package:haoke_rent/utils/common_toast.dart';
import 'package:haoke_rent/utils/string_util.dart';

bool showPassword = false;
bool showRePassword = false;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var rePasswordController = TextEditingController();

  _registerHandler() async {
    var userName = userNameController.text;
    var password = passwordController.text;
    var rePassword = rePasswordController.text;

    if (password != rePassword) {
      CommonToast.showToast('两次输入的密码不一致');
      return;
    }
    if (StringUtil.isBlank(userName) || StringUtil.isBlank(password)) {
      CommonToast.showToast('用户名或密码不能为空');
      return;
    }
    var params = {'username': userName, 'password': password};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('注册')),
      body: SafeArea(
        minimum: const EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            TextField(
              controller: userNameController,
              decoration: const InputDecoration(
                labelText: '用户名',
                hintText: '请输入用户名',
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: '密码',
                hintText: '请输入密码',
                suffixIcon: IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
              ),
              obscureText: !showPassword,
            ),
            const Padding(padding: EdgeInsets.all(10)),
            TextField(
              controller: rePasswordController,
              decoration: InputDecoration(
                labelText: '确认密码',
                hintText: '请再次输入密码',
                suffixIcon: IconButton(
                  icon: Icon(
                    showRePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      showRePassword = !showRePassword;
                    });
                  },
                ),
              ),
              obscureText: !showRePassword,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // 注册逻辑
                _registerHandler();
              },
              child: const Text('注册'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('已有账号？'),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('登录', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
