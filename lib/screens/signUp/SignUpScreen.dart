import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:poralekha_app/common/RoundedButton.dart';
import 'package:poralekha_app/common/CommonTextField.dart';
import 'package:poralekha_app/screens/Login/LoginScreen.dart';
import 'package:poralekha_app/screens/OtpScreen/OtpScreen.dart';
import 'package:poralekha_app/theme/myTheme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String? selectedRole;
  BuildContext? dialogContext;
  String? selectGender;

  Future addUserDetails(String name, String phone, String address, int age,
      String role, String gender, User? user) async {
    print("sdfjsj${name}");
    print("eikhane asche");
    try {
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'name': name,
        'phone': phone,
        'address': address,
        'age': age,
        'role': selectedRole,
        'gender': selectGender,
        'isAdmin': false,
        'isApproved': false,
        'class': '',
        'timestamp': FieldValue.serverTimestamp(),
        'img': ""
      });
    } catch (e) {
      print('Adding user data error: $e');
    }
    // Navigator.pop(dialogContext!);
  }

  // signUp(String name, String phone, String address, int age, String role,
  //     String gender, String confirmPassword) async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       dialogContext = context;
  //       return const AlertDialog(
  //         backgroundColor: Colors.transparent,
  //         content: SpinKitCircle(color: Colors.white, size: 50.0),
  //       );
  //     },
  //   );
  //   // You can implement password validation or any other custom logic here if needed
  // }

  //----------------------//

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieve verification code
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        // Call addUserDetails after verification is completed
        addUserDetails(
          nameController.text.trim(),
          phoneController.text.trim(),
          addressController.text.trim(),
          int.parse(ageController.text.trim()),
          selectedRole!,
          selectGender!,
          userCredential.user,
        );
      },
      verificationFailed: (FirebaseAuthException ex) {
        // Verification failed
        print('Verification failed: $ex');
        // You can handle the error here, such as displaying an error message to the user
      },
      codeSent: (String verificationId, int? resendToken) async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              verificationId: verificationId,
              // Pass phoneNumber to the OTP screen
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyTheme.canvousColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.1, vertical: screenHeight * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/poralekha-splash-screen-logo.png",
                  width: screenWidth * 0.4,
                ),
                SizedBox(height: screenHeight * 0.02),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Name",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                CommonTextField(
                  controller: nameController,
                  text: "Name",
                  obscure: false,
                  suffixIcon: const Icon(IconsaxBold.user),
                  textInputType: TextInputType.name,
                ),
                SizedBox(height: screenHeight * 0.01),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Phone Number",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                CommonTextField(
                  controller: phoneController,
                  text: "Phone Number",
                  obscure: false,
                  suffixIcon: const Icon(IconsaxBold.sms),
                  textInputType: TextInputType.phone,
                ),
                SizedBox(height: screenHeight * 0.01),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Address",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                CommonTextField(
                  controller: addressController,
                  text: "Address",
                  obscure: false,
                  suffixIcon: const Icon(IconsaxBold.location),
                  textInputType: TextInputType.streetAddress,
                ),
                SizedBox(height: screenHeight * 0.01),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Age",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                CommonTextField(
                  controller: ageController,
                  text: "Age",
                  obscure: false,
                  suffixIcon: const Icon(IconsaxBold.calendar),
                  textInputType: TextInputType.number,
                ),
                SizedBox(height: screenHeight * 0.01),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Gender",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.02),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1), blurRadius: 2)
                      ]),
                  child: DropdownButtonFormField<String>(
                    value: selectGender,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectGender = newValue;
                      });
                    },
                    items: ['Male', 'Female', "Other"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "Gender"),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Role",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.02),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                      )
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedRole,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue;
                      });
                    },
                    items: ['Student', 'Teacher']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Role",
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                RoundedButton(
                  title: "Sign Up",
                  width: double.infinity,
                  onTap: () {
                    if (nameController.text.trim().isEmpty ||
                        phoneController.text.trim().isEmpty ||
                        addressController.text.trim().isEmpty ||
                        ageController.text.trim().isEmpty ||
                        selectedRole == null ||
                        selectGender == null) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'Enter Required Fields',
                        btnOkColor: MyTheme.buttonColor,
                        btnOkOnPress: () {},
                      ).show();
                    } else {
                      // Set the values of selectedRole and selectGender
                      selectedRole =
                          selectedRole; // Set this to the actual value
                      selectGender =
                          selectGender; // Set this to the actual value
                      if (_isMobile(phoneController.text.trim())) {
                        verifyPhoneNumber(
                          phoneController.text.trim(),
                        );
                      } else {
                        // Invalid input
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'Invalid Mobile Number',
                          btnOkColor: MyTheme.buttonColor,
                          btnOkOnPress: () {},
                        ).show();
                      }
                    }
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.04,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.04,
                          color: Color(0xFF7E59FD),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final RegExp _mobileRegExp = RegExp(r'^\+?(88)?0?1[3456789][0-9]{8}\b');

  bool _isMobile(String input) {
    return _mobileRegExp.hasMatch(input);
  }
}
