import 'package:get/get.dart';

class MainController extends GetxController {
  var selectedIndex = 0.obs; // Observable integer to track the selected index

  void changePage(int index) {
    selectedIndex.value = index; // Change the selected index
  }
}
