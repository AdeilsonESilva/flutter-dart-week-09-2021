import 'package:app_filmes/application/ui/theme_extension.dart';
import 'package:app_filmes/models/cast_model.dart';
import 'package:flutter/material.dart';

class MovieDetailContentCast extends StatelessWidget {
  final CastModel? cast;
  const MovieDetailContentCast({Key? key, this.cast}) : super(key: key);

  Widget getImage() {
    var imagePath = cast?.image;

    if (imagePath == null) {
      return const SizedBox(
        width: 85,
        height: 85,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imagePath,
        width: 85,
        height: 85,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 95,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getImage(),
            Text(
              cast?.name ?? '',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              cast?.character ?? '',
              style: TextStyle(
                fontSize: 12,
                color: context.themeGrey,
              ),
            ),
          ],
        ));
  }
}
