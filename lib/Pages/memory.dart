import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'connect.dart';

class memorypage extends StatefulWidget {
  const memorypage({super.key});

  @override
  _memorypageState createState() => _memorypageState();
}

class _memorypageState extends State<memorypage> {
  List<FlSpot> dataPoints = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    timer = Timer.periodic(Duration(seconds: 5), (_timer) async {
      final data = await datas.fetchSystemMetrics();
      setState(() {
        //calcution
        double totalMemory = (data['memory_usage']['total_mb'] as num).toDouble();
        double usedMemory = (data['memory_usage']['used_mb'] as num).toDouble();
        double memoryUsage = (usedMemory / totalMemory) * 100;

        DateTime now = DateTime.now();//current time
        dataPoints.add(FlSpot(now.millisecondsSinceEpoch.toDouble(), memoryUsage));//new data point + currrent time

      if (dataPoints.length > 20) {
          dataPoints.removeAt(0);
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Usage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),

                  titlesData: FlTitlesData(

                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 10,  //interval
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          //x-axis as readable time
                          DateTime time = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                          return Text("${time.minute}:${time.second}");
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  minX: dataPoints.isNotEmpty
                      ? dataPoints.first.x
                      : DateTime.now().subtract(Duration(minutes: 1)).millisecondsSinceEpoch.toDouble(),
                  maxX: dataPoints.isNotEmpty
                      ? dataPoints.last.x
                      : DateTime.now().millisecondsSinceEpoch.toDouble(),
                  minY: 0,
                  maxY: 100,  
                  lineBarsData: [
                    LineChartBarData(
                      spots: dataPoints,
                      isCurved: true,
                      color: Colors.green,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
