import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

//display data chat with a oie chart
Widget datachart(String data, double usage, Color clr, Color clraccent,  {required double size}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children:[ SizedBox(
      width: size,
      height: size,
      child: RepaintBoundary(//repaint
        child: PieChart(
          dataMap: <String, double>{
            data: usage,//data for pie chart
          },
          chartType: ChartType.ring,
          centerText: data,
          initialAngleInDegree: 270,
          centerTextStyle:  TextStyle(
              fontSize: size / 10, fontWeight: FontWeight.bold, color: Colors.black ,backgroundColor: const Color.fromARGB(255, 254, 249, 249),),
          baseChartColor: clraccent,
          colorList: <Color>[
            clr,  //used part
          ],
          legendOptions: LegendOptions(showLegends: false),
          chartValuesOptions: const ChartValuesOptions(showChartValues: false),
          totalValue: 100,
        ),
      ),
    ),
    Text(
        "${usage.toStringAsFixed(2)}%", //usage percentange
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ]
  );
}

