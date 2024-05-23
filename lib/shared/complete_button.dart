import 'package:ecoville/shared/loading_circle.dart';
import 'package:ecoville/utilities/packages.dart';

class CompleteButton extends StatelessWidget {
  const CompleteButton({
    super.key,
    required this.text,
    this.width,
    this.height,
    required this.function,
    this.borderRadius = 25,
    this.isLoading = false,
    this.backgroundColor,
    this.isDisabled = false,
  });

  final Widget text;
  final double? width;
  final double? height;
  final Function() function;
  final double? borderRadius;
  final bool? isLoading;
  final Color? backgroundColor;
  final bool? isDisabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? MediaQuery.of(context).size.height * 0.075,
      width: width ?? MediaQuery.of(context).size.width,
      child: OutlinedButton(
          onPressed: isDisabled ?? false ? () {} : function,
          style: OutlinedButton.styleFrom(
            backgroundColor:
                isDisabled ?? false ? hintColor : backgroundColor ?? green,
            side: BorderSide.none,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 25),
            ),
          ),
          child: isLoading!
              ? const LoadingCircle(
                  color: Color(0xff53AB08),
                  size: 30,
                )
              : text),
    );
  }
}
