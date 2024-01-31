import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.amber,
        image: const DecorationImage(
          image: AssetImage('assets/images/english-banner.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
