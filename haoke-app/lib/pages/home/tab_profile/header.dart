import 'package:flutter/material.dart';
import 'package:haoke_rent/providers/auth_provider.dart';
import 'package:provider/provider.dart';


var loginTextStyle = const TextStyle(color: Colors.white, fontSize: 20);

class Header extends StatelessWidget {
  const Header({super.key});

  Widget _notLoginBuilder(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.red),
      height: 95,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            height: 65,
            width: 65,
            child: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://images.pexels.com/photos/33412303/pexels-photo-33412303.jpeg',
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(top: 25)),
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
                child: const Text('登录后可以体验更多',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _loginBuilder(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.currentUser;
    final avatarUrl = user?.avatar ??
        'https://images.pexels.com/photos/33412303/pexels-photo-33412303.jpeg';
    final username = user?.username ?? user?.nickname ?? '未设置用户名';

    return Container(
      decoration: const BoxDecoration(color: Colors.red),
      height: 95,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            height: 65,
            width: 65,
            child: CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl),
              onBackgroundImageError: (exception, stackTrace) {
                // TODO 图片加载失败时显示默认图像
                return;
              },
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(top: 25)),
                Text(username, style: loginTextStyle),
                GestureDetector(
                  onTap: () {
                    // TODO 可以跳转到个人资料编辑页
                    Navigator.pushNamed(context, '/profile/edit');
                  },
                  child: const Text('查看编辑个人资料',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLogin = true;
    // return isLogin ? _loginBuilder(context) : _notLoginBuilder(context);
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      // 如果正在加载，显示加载状态
      if (authProvider.isLoading) {
        return Container(
          decoration: const BoxDecoration(color: Colors.red),
          height: 95,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        );
      }
      // 根据登录状态显示不同的UI
      if (authProvider.isLoggedIn && authProvider.currentUser != null) {
        return _loginBuilder(context, authProvider);
      } else {
        return _notLoginBuilder(context);
      }
    });
  }
}
