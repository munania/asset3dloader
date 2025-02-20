import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Flutter3DController controller = Flutter3DController();
  Flutter3DController controller2 = Flutter3DController();

  List<String> availableAnimations1 = [];
  List<String> availableAnimations2 = [];
  String? selectedAnimation1;
  String? selectedAnimation2;

  double characterOnePhi = 280.0;
  double characterTwoPhi = 80.0;
  double radius = 10000.0;

  final String bizMan = 'assets/3d/business_man.glb';
  final String avatar = 'assets/3d/AppAvatar.glb';
  final String model1Url =
      "https://models.readyplayer.me/67b4309435bf1cf49b0ab02f.glb";
  final String model2Url =
      'https://models.readyplayer.me/67b45a54ad127257985354d8.glb';
  final String model3Url =
      "https://models.readyplayer.me/67b46919cd193cabb00dd377.glb";

  @override
  void initState() {
    super.initState();
    controller.onModelLoaded.addListener(() async {
      debugPrint('Model 1 is loaded: ${controller.onModelLoaded.value}');
      // Set initial camera orbit for model 1
      if (controller.onModelLoaded.value) {
        controller.setCameraOrbit(characterOnePhi, 90.0, radius);
        controller.playAnimation(animationName: 'Rig|walk');
      }
    });

    controller2.onModelLoaded.addListener(() async {
      debugPrint('Model 2 is loaded: ${controller2.onModelLoaded.value}');
      // Set initial camera orbit for model 2
      if (controller2.onModelLoaded.value) {
        controller2.setCameraOrbit(characterTwoPhi, 90.0, radius);
        controller2.playAnimation(animationName: 'Rig|walk');
      }
    });
  }

  void rotateCharacter(
      {required bool isCharacterOne, required bool isRotatingLeft}) {
    setState(() {
      if (isCharacterOne) {
        characterOnePhi += isRotatingLeft ? -25 : 25;
        controller.setCameraOrbit(characterOnePhi, 90.0, radius);
      } else {
        characterTwoPhi += isRotatingLeft ? -25 : 25;
        controller2.setCameraOrbit(characterTwoPhi, 90.0, radius);
      }
    });
  }

  Future<void> _fetchAnimations() async {
    final availableAnimationsAvatar1 =
        await controller.getAvailableAnimations();
    final availableAnimationsAvatar2 =
        await controller2.getAvailableAnimations();
    setState(() {
      availableAnimations1 = availableAnimationsAvatar1;
      availableAnimations2 = availableAnimationsAvatar2;
    });
  }

  setActiveAnimation(String animation, int avatar) {
    setState(() {
      if (avatar == 1) {
        selectedAnimation1 = animation;
      } else if (avatar == 2) {
        selectedAnimation2 = animation;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3DModel viewer')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Flutter3DViewer(
                    controller: controller,
                    src: model1Url,
                    onLoad: (String modelAddress) {
                      debugPrint('model 1 loaded : $modelAddress');
                      _fetchAnimations();
                    },
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Flutter3DViewer(
                    controller: controller2,
                    src: bizMan,
                    onLoad: (String modelAddress) {
                      debugPrint('model 2 loaded : $modelAddress');
                      _fetchAnimations();
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Avatar 1'),
                  Column(
                    children: [
                      ElevatedButton(
                          onPressed: () => rotateCharacter(
                              isCharacterOne: true, isRotatingLeft: false),
                          child: Icon(Icons.arrow_back)),
                      ElevatedButton(
                          onPressed: () {
                            controller.playAnimation(
                                animationName: selectedAnimation1);
                          },
                          child: Icon(Icons.play_arrow)),
                      ElevatedButton(
                          onPressed: () {
                            controller.pauseAnimation();
                          },
                          child: Icon(Icons.pause)),
                      ElevatedButton(
                          onPressed: () => rotateCharacter(
                              isCharacterOne: true, isRotatingLeft: true),
                          child: Icon(Icons.arrow_forward)),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Avatar 2'),
                  Column(
                    children: [
                      ElevatedButton(
                          onPressed: () => rotateCharacter(
                              isCharacterOne: false, isRotatingLeft: false),
                          child: Icon(Icons.arrow_back)),
                      ElevatedButton(
                          onPressed: () {
                            controller2.playAnimation(
                                animationName: selectedAnimation2);
                          },
                          child: Icon(Icons.play_arrow)),
                      ElevatedButton(
                          onPressed: () {
                            controller2.pauseAnimation();
                          },
                          child: Icon(Icons.pause)),
                      ElevatedButton(
                          onPressed: () => rotateCharacter(
                              isCharacterOne: false, isRotatingLeft: true),
                          child: Icon(Icons.arrow_forward)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
