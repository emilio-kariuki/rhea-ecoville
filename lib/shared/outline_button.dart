import 'package:ecoville/utilities/packages.dart';

class OutlineButton extends StatelessWidget {
  const OutlineButton({
    super.key,
    required this.text,
    this.width,
    this.height,
    this.borderRadius,
    required this.function,
  });

  final String text;
  final double? width;
  final double? height;
  final Function() function;
  final double ?borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? MediaQuery.of(context).size.height * 0.075,
      width: width ?? MediaQuery.of(context).size.width,
      child: OutlinedButton(
        onPressed: function,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(color: green, width: 1),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 25),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 2 * SizeConfig.textMultiplier,
            color: green,
          ),
        ),
      ),
    );
  }
}
