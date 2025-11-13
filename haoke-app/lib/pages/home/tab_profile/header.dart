import 'package:flutter/material.dart';

var loginTextStyle = TextStyle(color: Colors.white, fontSize: 20);

class Header extends StatelessWidget {
  const Header({super.key});

  Widget _notLoginBuilder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.red),
      height: 95,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            height: 65,
            width: 65,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://images.pexels.com/photos/33412303/pexels-photo-33412303.jpeg',
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 25)),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => {Navigator.of(context).pushNamed('login')},
                    child: Text('登录', style: loginTextStyle),
                  ),
                  Text('/', style: loginTextStyle),
                  GestureDetector(
                    onTap: () => {Navigator.of(context).pushNamed('register')},
                    child: Text('注册', style: loginTextStyle),
                  ),
                ],
              ),
              GestureDetector(
                child: Text('登录后可以体验更多', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _loginBuilder(BuildContext context) {
    String loginName = '张三';
    String loginAvator =
        'https://images.pexels.com/photos/33412303/pexels-photo-33412303.jpeg';
    return Container(
      decoration: BoxDecoration(color: Colors.red),
      height: 95,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            height: 65,
            width: 65,
            child: CircleAvatar(backgroundImage: NetworkImage(loginAvator)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 25)),
              Text(loginName, style: loginTextStyle),
              GestureDetector(
                child: Text('查看编辑个人资料', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLogin = true;
    return isLogin ? _loginBuilder(context) : _notLoginBuilder(context);
  }
}
