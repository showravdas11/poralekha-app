import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          //Profile Screen
          'Profile': 'Profile',
          'Personal Informatio': 'Personal Information',
          'Name': 'Name',
          'E-mail': 'E-mail',
          'Address': 'Address',
          'Age': 'Age',
          'Gender': 'Gender',
          'Utilities': 'Utilities',
          'Payment': 'Payment',
          'Click Here': 'Click Here',
          'Language': 'Language',
          'Log Out': 'Log Out',
          'Logout': 'Logout',
          'Edit Profile': 'Edit Profile',
          'Update': 'Update',
          'Edit': 'Edit',
          //Select class screen
          'Class Five': 'Class Five',
          'Class Six': 'Class Six',
          'Class Seven': 'Class Seven',
          'Class Eight': 'Class Eight',
          'Class Nine': 'Class Nine',
          'Class Ten': 'Class Ten',
          'HSC': 'HSC',
          'Select Your Class': 'Select Your Class',
          'Subjects': 'Subjects',
          'Chapters': 'Chapters',
          //Payment Screen
          'Choose your payment method': 'Choose your payment method',
          'bKash': 'bKash',
          'Nagad': 'Nagad',
          //Drawer List
          'Approve User': 'Approve User',
          'Manage Admin': 'Manage Admin',
          'Add Lecture': 'Add Lecture',
          'All Students': 'All Students',
          'All lectures': 'All lectures',
          'All subjects': 'All subjects',
          //Add Subject
          'Subject': 'Subject',
          'Class': 'Class',
          'Add Subject': 'Add Subject',
          'Enter Subject Name': 'Enter Subject Name',
          'Select Class': 'Select Class',
          'Add': 'Add',
          //Subject Details
          'Subject Details': 'Subject Details',
          'Subject:': 'Subject:',
          'Class:': 'Class:',
          'Chapter List': 'Chapter List',
          'See Details': 'See Details',
          //Bottam NavBar
          'Home': 'Home',
          'Chat': 'Chat',
          'Book': 'Book',
          //All Lecture Screen
          'Topic': 'Topic',
          'Teacher': 'Teacher',
          'Date': 'Date',
          'Time': 'Time',
          'Edit info': 'Edit info',
          //Add Lecture Screen
          'Enter Topic Name': 'Enter Topic Name',
          'Select Class Date': 'Select Class Date',
          'Teacher Name': 'Teacher Name',
          'Enter Teacher Name': 'Enter Teacher Name',
          'Start Time': 'Start Time',
          'Set Start Time': 'Set Start Time',
          'End Time': 'End Time',
          'Set End Time': 'Set End Time',
          'Class Link': 'Class Link',
          'Link': 'Link',
          'Platform': 'Platform',
          'Select Class Platform': 'Select Class Platform',
        },
        'bd_BAN': {
          //Profile Screen
          'Profile': 'প্রোফাইল',
          'Personal Information': 'ব্যক্তিগত তথ্যসমূহ',
          'Name': 'নাম',
          'E-mail': 'ই-মেইল',
          'Address': 'ঠিকানা',
          'Age': 'বয়স',
          'Gender': 'জেন্ডার',
          'Utilities': 'ইউটিলিটিস',
          'Payment': 'পেমেন্ট',
          'Click Here': 'এখানে ক্লিক করুন',
          'Language': 'ভাষা',
          'Log Out': 'লগ আউট',
          'Logout': 'লগআউট',
          'Edit Profile': 'এডিট প্রোফাইল',
          'Edit': 'এডিট',

          'Update': 'আপডেট',
          //Select class screen
          'Class Five': 'পঞ্চম শ্রেণি',
          'Class Six': 'ষষ্ঠ শ্রেণি',
          'Class Seven': 'সপ্তম শ্রেণি',
          'Class Eight': 'অষ্টম শ্রেণি',
          'Class Nine': 'নবম শ্রেণি',
          'Class Ten': 'দশম শ্রেণি',
          'HSC': 'এইচএসসি',
          'Select Your Class': 'আপনার শ্রেণি নির্বাচন করুন',
          'Subjects': 'বিষয়সমূহ',
          'Chapters': 'অধ্যায়সমূহ ',
          //Payment Screen
          'Choose your payment method': 'আপনার পরিশোধের পদ্ধতি পছন্দ করুন',
          'bKash': 'বিকাশ',
          'Nagad': 'নগদ',
          //Drawer List
          'Approve User': 'এপ্রোভ ইউজার',
          'Manage Admin': 'ম্যানেজ অ্যাডমিন',
          'Add Lecture': 'অ্যাড লেকচার',
          'All Students': 'সকল শিক্ষার্থী',
          'All lectures': 'সব লেকচার',
          'All subjects': 'সব বিষয়',
          //Add Subject
          'Subject': 'বিষয়',
          'Class': 'শ্রেণি',
          'Add Subject': 'বিষয় যুক্ত করুন',
          'Enter Subject Name': 'বিষয়ের নাম লিখুন',
          'Select Class': 'ক্লাস নির্বাচন করুন',
          'Add': 'যোগ করুন',

          //Subject Details
          'Subject Details': 'বিষয় বিবরণ',
          'Subject:': 'বিষয়:',
          'Class:': 'শ্রেণি:',
          'Chapter List': 'অধ্যায় তালিকা',
          'Show Details': 'বিস্তারিত দেখুন',
          //Bottam NavBar
          'Home': 'হোম',
          'Chat': 'চ্যাট',
          'Book': 'বই',
          //All Lecture Screen
          'Topic': 'বিষয়',
          'Teacher': 'শিক্ষক',
          'Date': 'তারিখ',
          'Time': 'সময়',
          'Edit info': 'এডিট ইনফো',
          //Add ChapterScreen
          'Add Chapter': 'অধ্যায় যোগ করুন',
          'Enter Chapter Name': 'অধ্যায় যোগ করুন',
          //All Lecture Screen
          'Enter Topic Name': 'বিষয়ের নাম লিখুন',
          'Select Class Date': 'ক্লাসের তারিখ নির্বাচন করুন',
          'Teacher Name': 'শিক্ষকের নাম',
          'Enter Teacher Name': 'শিক্ষকের নাম লিখুন',
          'Start Time': 'সময় শুরু',
          'Set Start Time': 'শুরুর সময় সেট করুন',
          'End Time': 'শেষ সময়',
          'Set End Time': 'শেষ সময় সেট করুন',
          'Class Link': 'ক্লাস লিঙ্ক',
          'Paste Link': 'লিঙ্ক পেস্ট করুন',
          'Platform': 'প্ল্যাটফর্ম',
          'Select Class Platform': 'ক্লাস প্ল্যাটফর্ম নির্বাচন করুন',
          //chapter topics screen
          'Chapter Topics': 'চ্যাপ্টার টপিকস',
          'PDF Book': 'পিডিএফ বুক',
          'Important Topics': 'ইম্পরট্যান্ট টপিকস',
          'Online Tutorials': 'অনলাইন টিউটোরিয়ালস',
          'Watch Now': 'ওয়াচ নাউ',
        },
      };

  static Future<Map<String, String>> getTranslations() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String selectedLanguage = preferences.getString('language') ?? 'en_US';
    return (Languages()).keys[selectedLanguage] ?? {};
  }
}
