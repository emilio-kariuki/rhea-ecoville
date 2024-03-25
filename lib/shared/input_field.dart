// ignore_for_file: must_be_immutable, lines_longer_than_80_chars
import 'package:ecoville/utilities/packages.dart';

class InputField extends StatelessWidget {
  const InputField({
    required this.controller,
    required this.validator,
    required this.hintText,
    super.key,
    this.obScureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.isEnabled = true,
    this.onChanged,
    this.onTap,
    this.textInputType,
    this.minLines = 1,
    this.maxLines = 5,
    this.fillColor = Colors.transparent,
    this.borderRadius = 10,
  });
  final TextEditingController controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obScureText;
  final String hintText;
  final bool? isEnabled;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final int minLines;
  final int maxLines;
  final TextInputType? textInputType;
  final Color? fillColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obScureText,
        enabled: isEnabled ?? true,
        keyboardType: textInputType ?? TextInputType.text,
        textInputAction: TextInputAction.next,
        minLines: minLines,
        maxLines: maxLines,
        onTap: onTap,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        style: GoogleFonts.inter(
          fontSize: 1.8 * SizeConfig.textMultiplier,
          fontWeight: FontWeight.w500,
          color: darkGrey,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          fillColor: fillColor,
          filled: true,
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: grey
          ),
          errorStyle:GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: red
          ),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          // border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(borderRadius),
          //     borderSide: const BorderSide(width: 1, color: Color(0xff808B9A))),
          border: InputBorder.none,
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(width: 1, color: red)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        ),
      ),
    );
  }
}
