import 'package:flutter/material.dart';
import 'package:pk_netflix/medels/contect_model.dart';
import 'package:pk_netflix/widgets/responsive.dart';
import 'package:pk_netflix/widgets/vertical_icon_button.dart';
import 'package:video_player/video_player.dart';

class ContentHeader extends StatelessWidget {
  final Content featuredContent;
  const ContentHeader({Key? key, required this.featuredContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _ContentHeaderMobile(featuredContent: featuredContent),
      desktop: _ContentHeaderDesktop(
        featuredContent: featuredContent,
      ),
    );
  }
}

class _ContentHeaderDesktop extends StatefulWidget {
  final Content featuredContent;
  const _ContentHeaderDesktop({Key? key, required this.featuredContent})
      : super(key: key);

  @override
  State<_ContentHeaderDesktop> createState() => _ContentHeaderDesktopState();
}

class _ContentHeaderDesktopState extends State<_ContentHeaderDesktop> {
  VideoPlayerController? _videoController;
  bool _isMuted = true;

  @override
  void initState() {
    _videoController =
        VideoPlayerController.network(widget.featuredContent.videoUrl!)
          ..initialize().then((_) => setState(() {}))
          ..play()
          ..setVolume(0.0);
    super.initState();
  }

  @override
  void dispose() {
    _videoController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _videoController!.value.isPlaying
          ? _videoController!.pause()
          : _videoController!.play(),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          AspectRatio(
            aspectRatio: _videoController!.value.isInitialized
                ? _videoController!.value.aspectRatio
                : 2.344,
            child: _videoController!.value.isInitialized
                ? VideoPlayer(_videoController!)
                : Image.asset(
                    widget.featuredContent.imageUrl,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: -1.0,
            child: AspectRatio(
              aspectRatio: _videoController!.value.isInitialized
                  ? _videoController!.value.aspectRatio
                  : 2.344,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.black, Colors.transparent],
                      end: Alignment.topCenter,
                      begin: Alignment.bottomCenter),
                ),
              ),
            ),
          ),
          Positioned(
            left: 60.0,
            right: 60.0,
            bottom: 150.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250,
                  child: Image.asset(widget.featuredContent.titleImageUrl!),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.featuredContent.description!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    shadows: [
                      Shadow(
                          color: Colors.black,
                          offset: Offset(2.0, 4.0),
                          blurRadius: 6.0)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    _PlayButton(),
                    const SizedBox(
                      width: 16.0,
                    ),
                    ElevatedButton.icon(
                      onPressed: () => print("More Info"),
                      icon: const Icon(
                        Icons.info_outline,
                        size: 30.0,
                      ),
                      label: const Text(
                        "More Info",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(25, 10, 30, 10),
                          primary: Colors.white,
                          onPrimary: Colors.black),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_videoController!.value.isInitialized)
                      IconButton(
                        splashRadius: 0.1,
                        onPressed: () => setState(() {
                          _isMuted
                              ? _videoController!.setVolume(100)
                              : _videoController!.setVolume(0.0);
                          _isMuted = _videoController!.value.volume == 0;
                        }),
                        icon: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentHeaderMobile extends StatelessWidget {
  final Content featuredContent;
  const _ContentHeaderMobile({Key? key, required this.featuredContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 500,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(featuredContent.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 500,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black, Colors.transparent],
                end: Alignment.topCenter,
                begin: Alignment.bottomCenter),
          ),
        ),
        Positioned(
          bottom: 110,
          child: SizedBox(
            width: 250,
            child: Image.asset(featuredContent.titleImageUrl!),
          ),
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              VerticalIconButtom(
                title: "List",
                icon: Icons.add,
                onTap: () => print("My List"),
              ),
              const _PlayButton(),
              VerticalIconButtom(
                title: "Info",
                icon: Icons.info_outline,
                onTap: () => print("Info"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          padding: !Responsive.isDesktop(context)
              ? const EdgeInsets.fromLTRB(15.0, 5.0, 20.0, 5.0)
              : const EdgeInsets.fromLTRB(25, 10, 30, 10),
          primary: Colors.white,
          onPrimary: Colors.black),
      onPressed: () => print("play"),
      icon: const Icon(Icons.play_arrow),
      label: const Text(
        "Play",
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
      ),
    );
  }
}
