import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yummy/screens/profile/profile_page.dart';
import 'package:yummy/utils/constants.dart';

class Graph2 extends StatelessWidget {
  Graph2({Key key}) : super(key: key);

  List<SalesData> salesData = [
    SalesData('Jun', 234),
    SalesData('Jul', 222),
    SalesData('Ago', 333),
    SalesData('Set', 442),
    SalesData('Out', 222)
  ];

  List<SalesData> salesData2 = [
    SalesData('Jun', 345),
    SalesData('Jul', 234),
    SalesData('Ago', 324),
    SalesData('Set', 234),
    SalesData('Out', 423)
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.azulClaro), //todo
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(text: 'Gastos dos ultimos 6 meses'),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<SalesData, String>>[
          LineSeries<SalesData, String>(
            dataSource: salesData,
            xValueMapper: (SalesData salesData, _) => salesData.month,
            yValueMapper: (SalesData salesData, _) => salesData.sales,
            name: 'Palha Italiana',
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
          LineSeries<SalesData, String>(
            dataSource: salesData2,
            xValueMapper: (SalesData salesData2, _) => salesData2.month,
            yValueMapper: (SalesData salesData2, _) => salesData2.sales,
            name: 'Banoffes',
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}
