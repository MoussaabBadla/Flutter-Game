import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  final game = DinoGame();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              game: game,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: NavigationKeys(
                onDirectionChanged: game.onArrowKeyChanged,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class DinoPlayer extends SpriteComponent with HasGameRef {
  DinoPlayer() : super(size: Vector2.all(100.0));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('Bunny/Purple.png');
    position = gameRef.size / 2;
  }

  Direction direction = Direction.none;

  @override
  void update(double dt) {
    super.update(dt);
    updatePosition(dt);
  }

  updatePosition(double dt) {
    switch (direction) {
      case Direction.up:
        position.y--;
        break;
      case Direction.down:
        position.y++;
        break;
      case Direction.left:
        position.x--;
        break;
      case Direction.right:
        position.x++;
        break;
      case Direction.none:
        break;
    }
  }
}

class DinoWorld extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('Environment.png');
    size = sprite!.originalSize;
  }
}

class DinoGame extends FlameGame {
  onArrowKeyChanged(Direction direction) {
    _dinoPlayer.direction = direction;
  }

  DinoPlayer _dinoPlayer = DinoPlayer();
  DinoWorld _dinoWorld = DinoWorld();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await add(_dinoWorld);
    await add(_dinoPlayer);
    _dinoPlayer.position = _dinoWorld.size / 1.5;
    camera.followComponent(_dinoPlayer,
        worldBounds: Rect.fromLTRB(0, 0, _dinoWorld.size.x, _dinoWorld.size.y));
  }
}

class NavigationKeys extends StatefulWidget {
  final ValueChanged<Direction>? onDirectionChanged;

  const NavigationKeys({Key? key, required this.onDirectionChanged})
      : super(key: key);

  @override
  State<NavigationKeys> createState() => _NavigationKeysState();
}

class _NavigationKeysState extends State<NavigationKeys> {
  Direction direction = Direction.none;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 170,
      child: Column(
        children: [
          ArrowKey(
            icons: Icons.keyboard_arrow_up,
            onTapDown: (det) {
              updateDirection(Direction.up);
            },
            onTapUp: (dets) {
              updateDirection(Direction.none);
            },
            onLongPressDown: () {
              updateDirection(Direction.up);
            },
            onLongPressEnd: (dets) {
              updateDirection(Direction.none);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ArrowKey(
                icons: Icons.keyboard_arrow_left,
                onTapDown: (det) {
                  updateDirection(Direction.left);
                },
                onTapUp: (dets) {
                  updateDirection(Direction.none);
                },
                onLongPressDown: () {
                  updateDirection(Direction.left);
                },
                onLongPressEnd: (dets) {
                  updateDirection(Direction.none);
                },
              ),
              ArrowKey(
                icons: Icons.keyboard_arrow_right,
                onTapDown: (det) {
                  updateDirection(Direction.right);
                },
                onTapUp: (dets) {
                  updateDirection(Direction.none);
                },
                onLongPressDown: () {
                  updateDirection(Direction.right);
                },
                onLongPressEnd: (dets) {
                  updateDirection(Direction.none);
                },
              ),
            ],
          ),
          ArrowKey(
            icons: Icons.keyboard_arrow_down,
            onTapDown: (det) {
              updateDirection(Direction.down);
            },
            onTapUp: (dets) {
              updateDirection(Direction.none);
            },
            onLongPressDown: () {
              updateDirection(Direction.down);
            },
            onLongPressEnd: (dets) {
              updateDirection(Direction.none);
            },
          ),
        ],
      ),
    );
  }

  void updateDirection(Direction newDirection) {
    direction = newDirection;
    widget.onDirectionChanged!(direction);
  }
}

class ArrowKey extends StatelessWidget {
  const ArrowKey({
    Key? key,
    required this.icons,
    required this.onTapDown,
    required this.onTapUp,
    required this.onLongPressDown,
    required this.onLongPressEnd,
  }) : super(key: key);
  final IconData icons;
  final Function(TapDownDetails) onTapDown;
  final Function(TapUpDetails) onTapUp;
  final Function() onLongPressDown;
  final Function(LongPressEndDetails) onLongPressEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onLongPress: onLongPressDown,
      onLongPressEnd: onLongPressEnd,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0x88ffffff),
          borderRadius: BorderRadius.circular(60),
        ),
        child: Icon(
          icons,
          size: 42,
        ),
      ),
    );
  }
}

enum Direction { up, down, left, right, none }
