import 'package:ecoville/utilities/packages.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key, required this.title, required this.onTap,
  });

  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
              color: black,
              fontSize: 2.2 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'See all',
            style: GoogleFonts.quicksand(
                color: black,
                fontSize: 1.8 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }
}
