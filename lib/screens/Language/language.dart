import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'Name': 'Name',
          'Profil': 'Profile',
          'Personal Informatio': 'Personal Information',
          'Language': 'Language',
          'Class Five': 'Class Five',
        },
        'bd_BAN': {
          'Name': 'নাম',
          'Profile': 'প্রোফাইল',
          'Personal Information': 'ব্যক্তিগত তথ্যসমূহ',
          'Language': 'ভাষা',
          'Class Five': 'পঞ্চম শ্রেণি',
        },
      };
}
