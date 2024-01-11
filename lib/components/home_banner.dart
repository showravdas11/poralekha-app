import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({
    super.key,
  });

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 195,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color.fromARGB(255, 78, 116, 249),
        image: const DecorationImage(
          image: const AssetImage(
            'assets/images/Circle.png',
          ),
          fit: BoxFit.cover,
          alignment: Alignment.centerLeft,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello,",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          wordSpacing: 2,
                          color: Colors.white),
                    ),
                    Text(
                      "Showrav Das",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                        wordSpacing: 2,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                    backgroundColor: Color(0xFF839EFB),
                    child: Icon(
                      Iconsax.notification5,
                      color: Colors.white,
                    ))
              ],
            ),
            SizedBox(
              height: 25,
            ),
            BannerSearchBar(),
          ],
        ),
      ),
    );
  }
}

class BannerSearchBar extends StatelessWidget {
  const BannerSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
      decoration: BoxDecoration(
          color: const Color(0xFFEDEDED),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2)
          ]),
      child: TextFormField(
        // obscureText: obscure,
        // controller: controller,
        // keyboardType: textInputType,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: "Search Here....",
          hintStyle: TextStyle(wordSpacing: 2, letterSpacing: 2),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
