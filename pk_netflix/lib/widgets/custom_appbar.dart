import 'package:flutter/material.dart';
import 'package:pk_netflix/assets.dart';
import 'package:pk_netflix/widgets/responsive.dart';

class CustomAppBar extends StatelessWidget {
  final double scrollOffset;
  const CustomAppBar({Key? key, this.scrollOffset = 0.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      color:
          Colors.black.withOpacity((scrollOffset / 350).clamp(0, 1).toDouble()),
      child: const Responsive(
        mobile: _customAppBarMobile(),
        desktop: _customAppBarDesktop(),
      ),
    );
  }
}

class _customAppBarDesktop extends StatelessWidget {
  const _customAppBarDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Image.asset(Assets.netflixLogo1),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _appBarButton(
                  title: "Home",
                  onTap: () => print("Home"),
                ),
                _appBarButton(
                  title: "TV Shows",
                  onTap: () => print("Tv Shows"),
                ),
                _appBarButton(
                  title: "Movies",
                  onTap: () => print("Movies"),
                ),
                _appBarButton(
                  title: "Latest",
                  onTap: () => print("Latest"),
                ),
                _appBarButton(
                  title: "My List",
                  onTap: () => print("My List"),
                )
              ],
            ),
          ),
          const Spacer(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => print('search'),
                  icon: const Icon(
                    Icons.search,
                    size: 28.0,
                    color: Colors.white,
                  ),
                ),
                _appBarButton(
                  title: "KIDS",
                  onTap: () => print("KIDS"),
                ),
                _appBarButton(
                  title: "DVD",
                  onTap: () => print("DVD"),
                ),
                IconButton(
                  onPressed: () => print('gift'),
                  icon: const Icon(
                    Icons.card_giftcard,
                    size: 28.0,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => print('notifications'),
                  icon: const Icon(
                    Icons.notifications,
                    size: 28.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _customAppBarMobile extends StatelessWidget {
  const _customAppBarMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Image.asset(Assets.netflixLogo0),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _appBarButton(
                  title: "TV Shows",
                  onTap: () => print("Tv Shows"),
                ),
                _appBarButton(
                  title: "Movies",
                  onTap: () => print("Movies"),
                ),
                _appBarButton(
                  title: "My List",
                  onTap: () => print("My List"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _appBarButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _appBarButton({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
