import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class AvatarScene extends StatefulWidget {
  const AvatarScene({super.key});

  @override
  State<AvatarScene> createState() => _HomePageState();
}

class _HomePageState extends State<AvatarScene> {
  Flutter3DController controller = Flutter3DController();
  bool isPlaying = true;

  List<String> animations = [];
  String? activeAnimation;

  double characterOnePhi = 350.0;
  double radius = 10000.0;

  final String avatar = 'assets/3d/combi.glb';

  @override
  void initState() {
    super.initState();
    controller.onModelLoaded.addListener(() async {
      debugPrint('Model 1 is loaded: ${controller.onModelLoaded.value}');
      if (controller.onModelLoaded.value) {
        controller.setCameraOrbit(characterOnePhi, 90.0, radius);
      }
    });
  }

  void rotateCharacter(
      {required bool isCharacterOne, required bool isRotatingLeft}) {
    setState(() {
      characterOnePhi += isRotatingLeft ? -25 : 25;
      controller.setCameraOrbit(characterOnePhi, 90.0, radius);
    });
  }

  Future<void> _fetchAnimations() async {
    final availableAnimations = await controller.getAvailableAnimations();
    setState(() {
      animations = availableAnimations;
    });
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        controller.playAnimation();
      } else {
        controller.pauseAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3DModel viewer')),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  rotateCharacter(isCharacterOne: true, isRotatingLeft: true);
                },
                icon: Icon(Icons.rotate_left),
              ),
              IconButton(
                onPressed: () {
                  rotateCharacter(isCharacterOne: false, isRotatingLeft: false);
                },
                icon: Icon(Icons.rotate_right),
              )
            ],
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Flutter3DViewer(
                    controller: controller,
                    src: avatar,
                    onLoad: (String modelAddress) {
                      debugPrint('model 1 loaded : $modelAddress');
                      _fetchAnimations();
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _showAnimationControls(true),
                child: const Text('Avatar 1 controls'),
              ),
              ElevatedButton(
                onPressed: () => _showAnimationControls(false),
                child: const Text('Avatar 2 controls'),
              )
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePlayPause,
        child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }

  void _showAnimationControls(bool isFirstAvatar) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return _buildBottomSheet(isFirstAvatar);
      },
    );
  }

  Widget _buildBottomSheet(bool isFirstAvatar) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isFirstAvatar ? 'Avatar 1 Animations' : 'Avatar 2 Animations',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (isFirstAvatar) {
                    controller.playAnimation(animationName: 'ManIdle');
                  } else {
                    controller.playAnimation(animationName: 'WomanIdle');
                  }
                  setState(() => isPlaying = true); // Update play state
                  Navigator.pop(context);
                },
                child: const Text('Idle'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (isFirstAvatar) {
                    controller.playAnimation(animationName: 'ManStumble');
                  } else {
                    controller.playAnimation(animationName: 'WomanStumble');
                  }
                  setState(() => isPlaying = true); // Update play state
                  Navigator.pop(context);
                },
                child: const Text('Stumble'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (isFirstAvatar) {
                    controller.playAnimation(animationName: 'ManBaseball');
                  } else {
                    controller.playAnimation(animationName: 'WomanBaseball');
                  }
                  setState(() => isPlaying = true); // Update play state
                  Navigator.pop(context);
                },
                child: const Text('Baseball'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
