import 'package:ecoville/utilities/packages.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 5 * SizeConfig.widthMultiplier),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: "By using $APP_NAME, You agree to our ",
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontWeight: FontWeight.w600, fontSize: 12.5, color: white),
          ),
          TextSpan(
            text: "Terms of Service, Privacy Policy ",
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.w600, fontSize: 12.5, color: const Color(0xff53AB08,),),
          ),
          TextSpan(
            text: "and ",
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                  color: white
                ),
          ),
          TextSpan(
            text: "Agreement",
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.w600, fontSize: 12.5, color: const Color(0xff53AB08,),),
          ),
        ]),
      ),
    );
  }
}