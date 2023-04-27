import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final double? size;
  final FontWeight? weight;
  final Color? color;
  final int? maxline;
  final double? spacing;
  final TextOverflow? flow;
  final TextAlign? align;
  final bool? isGradiant;
  final List<Color>? colors;
  final GradientDirection? direction;
  final bool? isFit;
  final bool? isMat;
  const CustomText(
      {Key? key,
      this.text,
      this.size,
      this.weight,
      this.color,
      this.maxline,
      this.flow,
      this.spacing,
      this.align,
      this.isGradiant,
      this.colors,
      this.direction,
      this.isFit,
      this.isMat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isGradiant == true
        ? GradientText(
            textAlign: align,
            maxLines: maxline,
            gradientDirection: direction,
            text ?? '',
            style: TextStyle(
              fontWeight: weight,
              fontSize: size,
              overflow: flow,
            ),
            colors: colors ?? [],
          )
        : isFit == true
            ? FittedBox(
                child: isMat == true
                    ? Material(
                        type: MaterialType.transparency,
                        child: Text(text ?? '',
                            maxLines: maxline,
                            textAlign: align,
                            style: TextStyle(
                                color: color,
                                fontSize: size,
                                fontWeight: weight,
                                overflow: flow,
                                letterSpacing: spacing)),
                      )
                    : Text(text ?? '',
                        maxLines: maxline,
                        textAlign: align,
                        style: TextStyle(
                            color: color,
                            fontSize: size,
                            fontWeight: weight,
                            overflow: flow,
                            letterSpacing: spacing)),
              )
            : isMat == true
                ? Material(
                    type: MaterialType.transparency,
                    child: Text(text ?? '',
                        maxLines: maxline,
                        textAlign: align,
                        style: TextStyle(
                            color: color,
                            fontSize: size,
                            fontWeight: weight,
                            overflow: flow,
                            letterSpacing: spacing)),
                  )
                : Text(text ?? '',
                    maxLines: maxline,
                    textAlign: align,
                    style: TextStyle(
                        color: color,
                        fontSize: size,
                        fontWeight: weight,
                        overflow: flow,
                        letterSpacing: spacing));
  }
}
