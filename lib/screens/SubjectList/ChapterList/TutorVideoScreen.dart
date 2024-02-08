import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TutorVideoScreen extends StatefulWidget {
  const TutorVideoScreen({Key? key}) : super(key: key);

  @override
  _TutorVideoScreenState createState() => _TutorVideoScreenState();
}

class _TutorVideoScreenState extends State<TutorVideoScreen> {
  late YoutubePlayerController _controller;
  double _startPosition = 0.0; // Variable to store the video playback position
  bool _isFullScreen =
      false; // Variable to track if video is in full screen mode

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    String videoUrl = 'https://youtu.be/orbkg5JH9C8?si=wlaQroTZesImPrCj';

    String videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        // autoPlay: true,
        mute: false,
        loop: true,
        controlsVisibleAtStart: true,
      ),
    );
    _controller
        .addListener(_onControllerChange); // Add a listener to the controller
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChange() {
    if (_controller.value.isPlaying) {
      _startPosition = _controller.value.position.inSeconds.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            _isFullScreen = orientation == Orientation.landscape;
            return YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.red,
                  handleColor: Colors.red,
                ),
                onReady: () {
                  if (_isFullScreen) {
                    _controller
                        .seekTo(Duration(seconds: _startPosition.toInt()));
                  }
                },
              ),
              builder: (context, player) {
                return _isFullScreen
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          player,
                          IconButton(
                            icon: const Icon(Iconsax.close_square),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            player,
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Iconsax.arrow_left_2),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                const Text(
                                  "Chapter Topic Name",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis viverra purus sit amet nulla fermentum, vitae malesuada libero bibendum. Aliquam erat volutpat. Nullam consequat quam et sapien consectetur, sed vulputate velit ultricies. Vestibulum in libero leo. Nullam et magna id arcu interdum tristique.",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey.shade600),
                              ),
                            )
                          ],
                        ),
                      );
              },
            );
          },
        ),
      ),
    );
  }
}
