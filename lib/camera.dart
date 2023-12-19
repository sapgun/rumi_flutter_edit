import 'package:flutter/material.dart';
import 'package:senior_fitness_app/video2.dart';


class Camera extends StatelessWidget {
  const Camera({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rumi',
      home: CameraPage(),
    );
  }
}

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/rumi.png',
                width: 120.0,
                height: 120.0,
              ),

              const SizedBox(
                height: 10.0,
              ),

              const SizedBox(
                height: 50,
              ),
              const Text(
                '카메라 설치가 완료되면\n 다음버튼을 눌러주세요.',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 200),
              TextButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VideoScreen()),
                  );

                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF1F4EF5),
                  minimumSize: const Size(210.0, 70.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  '다음',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
