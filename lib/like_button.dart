import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({Key? key}) : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  bool _isLiked = false;
  late final Animation tiltLikeIcon;

  late final AnimationController likeButtonController;
  late final Animation zoomIconLikeBtn;
  late final Animation zoomTextLikeButton;

  @override
  void initState() {
    likeButtonController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    tiltLikeIcon = Tween(begin: 0.0, end: 0.8).animate(likeButtonController);
    zoomIconLikeBtn = Tween(begin: 1.0, end: 0.5).animate(likeButtonController);
    zoomTextLikeButton =
        Tween(begin: 1.0, end: 0.5).animate(likeButtonController);

    tiltLikeIcon.addListener(() {
      setState(() {});
    });
    zoomTextLikeButton.addListener(() {
      setState(() {});
    });
    zoomIconLikeBtn.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    likeButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isLiked = !_isLiked;
          });
          if (_isLiked) {
            likeButtonController.forward();
          } else {
            likeButtonController.reverse();
          }
        },
        child: Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: _isLiked ? Colors.blue : Colors.grey)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Transform.scale(
                scale: _isLiked
                    ? handleOutputRangeZoomInIconLike(zoomIconLikeBtn.value)
                    : zoomIconLikeBtn.value,
                child: Transform.rotate(
                  angle: _isLiked
                      ? handleOutputRangeTiltIconLike(tiltLikeIcon.value)
                      : tiltLikeIcon.value,
                  child: _isLiked
                      ? const Icon(
                          Icons.thumb_up,
                          size: 30,
                          color: Colors.blue,
                        )
                      : const Icon(
                          Icons.thumb_up_alt_outlined,
                          size: 30,
                        ),
                ),
              ),
              Transform.scale(
                scale: _isLiked
                    ? handleOutputRangeZoomInIconLike(zoomTextLikeButton.value)
                    : zoomTextLikeButton.value,
                child: Text('Like',
                    style: TextStyle(
                        fontSize: 30,
                        color: _isLiked ? Colors.blue : Colors.grey)),
              )
            ],
          ),
        ),
      ),
    );
  }

  double handleOutputRangeTiltIconLike(double value) {
    if (value <= 0.2) {
      return value;
    } else if (value <= 0.6) {
      return 0.4 - value;
    } else {
      return -(0.8 - value);
    }
  }

  double handleOutputRangeZoomInIconLike(double value) {
    if (value >= 0.8) {
      return value;
    } else if (value >= 0.4) {
      return 1.6 - value;
    } else {
      return 0.8 + value;
    }
  }
}
