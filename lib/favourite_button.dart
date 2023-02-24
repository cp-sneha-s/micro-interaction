import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({Key? key}) : super(key: key);

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton>
    with SingleTickerProviderStateMixin {
  bool _isFavourite = false;
  late final AnimationController favouriteButtonController;

  @override
  void initState() {
    favouriteButtonController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600), value: 1);
    super.initState();
  }

  @override
  void dispose() {
    favouriteButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isFavourite = !_isFavourite;
          });

          _isFavourite
              ? favouriteButtonController
                  .reverse()
                  .then((value) => favouriteButtonController.forward())
              : null;
        },
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 0.8).animate(CurvedAnimation(
              parent: favouriteButtonController, curve: Curves.easeInOut)),
          child: _isFavourite
              ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 80,
                )
              : const Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                  size: 50,
                ),
        ),
      ),
    );
  }
}
