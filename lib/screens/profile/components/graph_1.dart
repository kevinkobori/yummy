import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yummy/screens/profile/profile_page.dart';
import 'package:yummy/utils/constants.dart';

class Graph1 extends StatelessWidget {
  Graph1({Key key}) : super(key: key);

  List<SalesData> salesData = [
    SalesData('Jun', 350),
    SalesData('Jul', 280),
    SalesData('Ago', 340),
    SalesData('Set', 320),
    SalesData('Out', 400)
  ];

  List<SalesData> salesData2 = [
    SalesData('Jun', 230),
    SalesData('Jul', 450),
    SalesData('Ago', 320),
    SalesData('Set', 120),
    SalesData('Out', 500)
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.azulMarinhoEscuro), //todo
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
            name: 'Brigadeiro',
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
          LineSeries<SalesData, String>(
            dataSource: salesData2,
            xValueMapper: (SalesData salesData2, _) => salesData2.month,
            yValueMapper: (SalesData salesData2, _) => salesData2.sales,
            name: 'Mousse de Limão',
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}
