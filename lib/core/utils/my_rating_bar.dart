import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Widget myRatingBar(
  initialRating, {
  double? size,
  ValueChanged<int>? onValueChanged,
}) {
  return RatingBar.builder(
      itemCount: 5,
      itemBuilder: (context, _) {
        return const Icon(
          Icons.star,
          color: Colors.amber,
        );
      },
      initialRating: double.parse(initialRating.toString()),
      updateOnDrag: false,
      itemSize: size ?? 20.0,
      itemPadding: const EdgeInsets.only(right: 2.0),
      onRatingUpdate: (rating) {
        if (onValueChanged != null) {
          onValueChanged(rating.round());
        }
      });
}
