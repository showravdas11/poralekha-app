import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({super.key, required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black.withOpacity(0.5)),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 55,
              width: 70,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1), blurRadius: 10)
                  ]),
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {},
                icon: Image(
                  width: 40.0,
                  height: 40.0,
                  image: AssetImage("assets/images/google-icon.png"),
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Container(
              height: 55,
              width: 70,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    )
                  ]),
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {},
                icon: Image(
                  width: 40.0,
                  height: 40.0,
                  image: AssetImage("assets/images/facebook-icon.png"),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
