import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:senior_fitness_app/posedetecter.dart';
import 'package:senior_fitness_app/SFT.dart';


class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('images/dumbell.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _controller!.value.isInitialized
                ? AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            )
                : CircularProgressIndicator(),
            ElevatedButton(
              onPressed: () {
                // 다음 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PoseDetectorView()),
                );
              },
              child: Text('다음 페이지'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller!.value.isPlaying
                ? _controller!.pause()
                : _controller!.play();
          });
        },
        child: Icon(
          _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                // 메인 페이지로 이동
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Myfit()),
                );
              },
              child: Text('운동페이지로 이동'),
            )
          ],
        ),
      ),
    );
  }
}
