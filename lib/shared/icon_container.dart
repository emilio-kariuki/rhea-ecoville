import 'package:ecoville/utilities/packages.dart';

class IconContainer extends StatelessWidget {
  const IconContainer({
    super.key, required this.icon, required this.function,
  });

  final String icon;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: lightGrey, shape: BoxShape.circle),
        child: SvgPicture.asset(
          icon,
          height: 2.8 * SizeConfig.heightMultiplier,
          width: 2.8 * SizeConfig.heightMultiplier,
          color: black,
        ),
      ),
    );
  }
}
