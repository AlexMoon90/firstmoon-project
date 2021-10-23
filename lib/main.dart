//@dart=2.9

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  VideoPlayerController _controllerJjan;
  Duration _position;

  Future<void> _initVPfuture;
  Future<void> _initVPfuturejjan;
  List<Duration> timeList;

  int jjan;
  //짠 버튼을 눌렀을 때 영상1이 플레잉되고 있는지 영상2가 되고있는지 구별
  int initNumber;
  int _count;
  Duration _pushTime;
  int _paushTimeNumber;
  //퓨쳐빌더에 초기변수로 지정하기 위한 구분변

  @override
  void initState() {
    // VideoPlayerController를 저장하기 위한 변수를 만듭니다. VideoPlayerController는
    // asset, 파일, 인터넷 등의 영상들을 제어하기 위해 다양한 생성자를 제공합니다.
    initNumber = 1;
    _pushTime = Duration();
    _paushTimeNumber = 0;

    timeList = [
      Duration(),
      Duration(seconds: 1, milliseconds: 800),
      Duration(seconds: 3, milliseconds: 100),
      Duration(seconds: 4, milliseconds: 900),
      Duration(seconds: 7, milliseconds: 000),
      Duration(seconds: 9, milliseconds: 100),
      Duration(seconds: 12, milliseconds: 800),
      Duration(seconds: 15, milliseconds: 000),
      Duration(seconds: 19, milliseconds: 000),
      Duration(seconds: 20, milliseconds: 820),
    ];

    _controller = VideoPlayerController.asset(
      'assets/test1second.mov',
    );

    _controllerJjan = VideoPlayerController.asset(
      'assets/jjanjjan.mov',
    );
    // _controller.initialize();
    // _controller2.initialize();

    // 컨트롤러를 초기화하고 추후 사용하기 위해 Future를 변수에 할당합니다.
    _initVPfuture = _controller.initialize();
    _initVPfuturejjan = _controllerJjan.initialize();
    _count = 0;

    _controller.addListener(() {
      _position = _controller.value.position;

      /* if(jjan==1&&_position>Duration()&& _position<Duration(seconds: 10)) {
          print('체크체크');
          _count++;
          if(_count==1)
          setState(() {
            _controller.pause().whenComplete(() => print('멈춘시간 : $_position'));


          });} */
      if (jjan == 0) {
        if (_position >= timeList[_paushTimeNumber] &&
            _position <
                timeList[_paushTimeNumber] + Duration(milliseconds: 100)) {
          _count++;
          print('카운터 : $_count');

          if (_count == 1) {
            setState(() {
              _controllerJjan.play();
              _controller
                  .pause()
                  .whenComplete(() => print('멈춘시간 : $_position'));
            });
          }
        }
      }
    });

    _controllerJjan.addListener(() {
      if (jjan == 0 &&
          !_controllerJjan.value.isPlaying &&
          _controllerJjan.value.position == _controllerJjan.value.duration) {
        setState(() {
          jjan = 1;
          _controller.play();
          _controllerJjan.seekTo(Duration());
          _count = 0;
        });
      }
    });

    // 비디오를 반복 재생하기 위해 컨트롤러를 사용합니다.

    jjan = 1;
    _controller.play();
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // 자원을 반환하기 위해 VideoPlayerController를 dispose 시키세요.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alcohol Friend'),
      ),
      // VideoPlayerController가 초기화를 진행하는 동안 로딩 스피너를 보여주기 위해
      // FutureBuilder를 사용합니다.
      body: FutureBuilder(
        future: jjan == 0 ? _initVPfuturejjan : _initVPfuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print('jjanNUmber $jjan');

            // 만약 VideoPlayerController 초기화가 끝나면, 제공된 데이터를 사용하여
            // VideoPlayer의 종횡비를 제한하세요.
            //  Timer(Duration(seconds: 5, milliseconds: 000), () { _controller.pause();});

            /* _controller.play(); */
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // 영상을 보여주기 위해 VideoPlayer 위젯을 사용합니다.
              child: jjan == 0
                  ? VideoPlayer(_controllerJjan)
                  : VideoPlayer(_controller),
            );
          } else {
            // 만약 VideoPlayerController가 여전히 초기화 중이라면,
            // 로딩 스피너를 보여줍니다.
            return Container(child: Image.asset('images/myself1.jpg'));
          }
        },
      ),
      floatingActionButton: Container(
        width: 100,
        height: 100,
        child: FloatingActionButton(
            onPressed: _controllerJjan.value.isPlaying
                ? null
                : () {
                    if (jjan == 1) {
                      print('누른시점 $_controller.value.position');
                      _pushTime = _controller.value.position;

                      for (int i = 0; i < timeList.length - 1; i++) {
                        print('번호 $i');
                        if (_pushTime >= timeList[i] &&
                            _pushTime < timeList[i + 1]) {
                          _paushTimeNumber = i + 1;
                          print('포즈순서번호 $_paushTimeNumber');
                        }
                      }

                      jjan = 0;
                      print("짠짠짠 $jjan");
                    }

                    // 재생/일시 중지 기능을 `setState` 호출로 감쌉니다. 이렇게 함으로써 올바른 아이콘이
                    // 보여집니다.
                  },
            // 플레이어의 상태에 따라 올바른 아이콘을 보여줍니다.
            child: Text(
              '짠',
              style: TextStyle(fontSize: 50),
            )),
      ),
    ); // 이 마지막 콤마는 buld 메드에 자동 서식이 잘 적용될 수 있도록 도와줍니다.
  }
}
