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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('예시 영상'),
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
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      // Move to the next page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PoseDetectorView()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF1F4EF5), // Color code CEE9E3
                      minimumSize: const Size(150.0, 70.0),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      '다음',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16), // Adjust the spacing if needed
                Container(
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _controller!.value.isPlaying
                            ? _controller!.pause()
                            : _controller!.play();
                      });
                    },
                    backgroundColor: Color(0xFF1F4EF5),
                    child: Icon(
                      _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Color(0xFFffffff),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: Color(0xffffffff),
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
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF1F4EF5), // 색상 코드 CEE9E3
                minimumSize: const Size(210.0, 70.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('운동페이지로 이동',
                style: TextStyle(color: Colors.white, fontSize: 30.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
