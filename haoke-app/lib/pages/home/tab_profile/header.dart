import 'package:flutter/material.dart';
import 'package:haoke_rent/l10n/app_localizations.dart';
import 'package:haoke_rent/providers/auth_provider.dart';
import 'package:provider/provider.dart';

const loginTextStyle =
    TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700);

class Header extends StatelessWidget {
  const Header({super.key});

  Widget _notLoginBuilder(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
            colors: [Color(0xFF0F8F7A), Color(0xFF3DBD9A)]),
      ),
      height: 116,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 31,
            backgroundImage: NetworkImage(
              'https://images.pexels.com/photos/33412303/pexels-photo-33412303.jpeg',
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('login'),
                    child: Text(context.tr('login'), style: loginTextStyle),
                  ),
                  const Text(' / ', style: loginTextStyle),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('register'),
                    child: Text(context.tr('register'), style: loginTextStyle),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('sign_in_unlock'),
                style: const TextStyle(color: Colors.white, fontSize: 13),
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
    final username = user?.username ?? user?.nickname ?? context.tr('guest');

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
            colors: [Color(0xFF0F8F7A), Color(0xFF3DBD9A)]),
      ),
      height: 116,
      child: Row(
        children: [
          CircleAvatar(radius: 31, backgroundImage: NetworkImage(avatarUrl)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username, style: loginTextStyle),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile/edit');
                  },
                  child: Text(
                    context.tr('view_edit_profile'),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return Container(
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            height: 116,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF0F8F7A),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        }

        if (authProvider.isLoggedIn && authProvider.currentUser != null) {
          return _loginBuilder(context, authProvider);
        }
        return _notLoginBuilder(context);
      },
    );
  }
}
