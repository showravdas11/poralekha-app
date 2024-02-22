import 'package:flutter/material.dart';
import 'package:poralekha_app/common/AppBar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class GdpData {
  final String continent;
  final int gdp;

  GdpData({required this.continent, required this.gdp});
}

class PiChart extends StatefulWidget {
  const PiChart({super.key});

  @override
  State<PiChart> createState() => _PiChartState();
}

class _PiChartState extends State<PiChart> {
  late TooltipBehavior _tooltipbehavior;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _tooltipbehavior = TooltipBehavior(enable: true);
  }
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: _tooltipbehavior,
      series: <CircularSeries>[
        DoughnutSeries<GdpData, String>(
          dataSource: getChartData(),
          // Pass your chart data
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
    );
  }
  // Dummy chart data, replace this with your actual chart data
  List<GdpData> getChartData() {
    final List<GdpData> charData = [
      GdpData(continent: "Class Six", gdp: 2000),
      GdpData(continent: "Class Seven", gdp: 5000),
      GdpData(continent: "Class Eight", gdp: 1500),
      GdpData(continent: "Class Nine", gdp: 3000),
      GdpData(continent: "Class Ten", gdp: 5000),
    ];
    return charData;
  }
}