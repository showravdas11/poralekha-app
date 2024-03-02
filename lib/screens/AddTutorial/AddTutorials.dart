import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:poralekha_app/common/CommonTextField.dart';

class AddTutorialsScreen extends StatefulWidget {
  const AddTutorialsScreen({Key? key}) : super(key: key);

  @override
  State<AddTutorialsScreen> createState() => _AddTutorialsScreenState();
}

class _AddTutorialsScreenState extends State<AddTutorialsScreen> {
  List<Widget> _tutorialsWidgets = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Tutorials",
        leadingOnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleChildScrollView(
              child: Column(
                children: _tutorialsWidgets.map((widget) {
                  return Column(
                    children: [
                      widget,
                      SizedBox(height: 20),
                    ],
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _tutorialsWidgets.add(_buildCummonTextField(
                          _nameController,
                          _linkController)); // Add the text field widget to the list
                      _nameController =
                          TextEditingController(); // Reset the controller for the next text field
                      _linkController =
                          TextEditingController(); // Reset the controller for the next text field
                    });
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildCummonTextField(TextEditingController nameController,
    TextEditingController linkController) {
  return Column(
    children: [
      CommonTextField(
        controller: nameController,
        text: "Tutorials Name",
        textInputType: TextInputType.text,
        obscure: false,
        suffixIcon: const Icon(Iconsax.add_circle),
      ),
      const SizedBox(
        height: 20,
      ),
      CommonTextField(
        controller: linkController,
        text: "Paste Tutorials Link",
        textInputType: TextInputType.text,
        obscure: false,
        suffixIcon: const Icon(Iconsax.add_circle),
      ),
    ],
  );
}
