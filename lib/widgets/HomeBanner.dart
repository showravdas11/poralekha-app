import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: screenHeight * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // color: Colors.amber,
        image: const DecorationImage(
          image: AssetImage('assets/images/english-banner.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
