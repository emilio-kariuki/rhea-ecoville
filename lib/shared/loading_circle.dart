import 'package:ecoville/utilities/packages.dart';

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({
    super.key,
    this.size = 30,
    this.color,
  });

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Center(
        child: SpinKitCircle(
          color: color ?? secondary,
          size: size!,
        ),
      ),
    );
  }
}
