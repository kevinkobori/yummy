import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yummy/screens/profile/profile_page.dart';
import 'package:yummy/utils/constants.dart';

class Graph3 extends StatelessWidget {
  Graph3({Key key}) : super(key: key);

  List<SalesData> salesData = [
    SalesData('Jun', 234),
    SalesData('Jul', 222),
    SalesData('Ago', 345),
    SalesData('Set', 455),
    SalesData('Out', 345)
  ];

  List<SalesData> salesData2 = [
    SalesData('Jun', 234),
    SalesData('Jul', 423),
    SalesData('Ago', 233),
    SalesData('Set', 332),
    SalesData('Out', 444)
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
            name: 'Brownie',
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
          LineSeries<SalesData, String>(
            dataSource: salesData2,
            xValueMapper: (SalesData salesData2, _) => salesData2.month,
            yValueMapper: (SalesData salesData2, _) => salesData2.sales,
            name: 'Cookie Americano',
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}
