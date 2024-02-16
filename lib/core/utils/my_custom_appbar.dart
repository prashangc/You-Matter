import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';

class MyCustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  const MyCustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(50);
  @override
  State<MyCustomAppBar> createState() => _MyCustomAppBarState();
}

class _MyCustomAppBarState extends State<MyCustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      width: maxWidth(context),
      height: 120,
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 10.0),
      color: ColorConstant.backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  color: ColorConstant.kTransparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorConstant.kBlack, width: 2.0)),
              child: Icon(
                Icons.arrow_back,
                size: 18.0,
                color: ColorConstant.kBlack,
              ),
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Text(
              widget.title,
              style: kStyle12B.copyWith(
                fontSize: 20.0,
                color: ColorConstant.kBlack,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(width: 20.0),
        ],
      ),
    );
  }
}
