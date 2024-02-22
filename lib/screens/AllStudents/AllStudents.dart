import 'package:flutter/material.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class AllStudent extends StatefulWidget {
  const AllStudent({Key? key});

  @override
  State<AllStudent> createState() => _AllStudentState();
}

class _AllStudentState extends State<AllStudent> {
  late TooltipBehavior _tooltipbehavior;

  @override
  void initState() {
    _tooltipbehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "All Student",
        leadingOnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('test-students')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child:
                        CircularProgressIndicator()); // Display loading indicator while waiting for data
              }
              // Calculate total number of users
              int totalUsers = snapshot.data?.docs.length ?? 0;
              return Column(
                children: [
                  SfCircularChart(
                    legend: Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap,
                    ),
                    tooltipBehavior: _tooltipbehavior,
                    series: <CircularSeries>[
                      DoughnutSeries<GdpData, String>(
                        dataSource: getChartData(), // Pass your chart data
                        xValueMapper: (GdpData data, _) => data.continent,
                        yValueMapper: (GdpData data, _) => data.gdp,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          // color: Colors.amber,
                          // borderColor: Colors.black,
                        ),
                        enableTooltip: true,
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Total Student: $totalUsers",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // Dummy chart data, replace this with your actual chart data
  List<GdpData> getChartData() {
    final List<GdpData> charData = [
      GdpData(continent: "Class Six", gdp: 2470),
      GdpData(continent: "Class Seven", gdp: 3301),
      GdpData(continent: "Class Eight", gdp: 5604),
      GdpData(continent: "Class Nine", gdp: 2945),
      GdpData(continent: "Class Ten", gdp: 5569),
    ];
    return charData;
  }
}

class GdpData {
  final String continent;
  final int gdp;

  GdpData({required this.continent, required this.gdp});
}
