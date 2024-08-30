import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'connect.dart';

class diskpage extends StatefulWidget {
  const diskpage({super.key});

  @override
  _diskpageState createState() => _diskpageState();
}

class _diskpageState extends State<diskpage> {
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
        //extract total and used disk
        double totalDisk= (data['disk_usage']['total_mb'] as num).toDouble();
        double usedDisk= (data['disk_usage']['used_mb'] as num).toDouble();

        double diskusage = (usedDisk / totalDisk) * 100;//calculate
        DateTime now = DateTime.now();
        dataPoints.add(FlSpot(now.millisecondsSinceEpoch.toDouble(), diskusage));//add new data point to the current time
       
        if (dataPoints.length > 20) { //latest 20 points
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
        title: Text('Disk Usage'),
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
                        showTitles: true,//show label
                        interval: 10,  //interval b/w y axis
                        reservedSize: 40, //space for y axis
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        reservedSize: 22,
                      getTitlesWidget: (value, meta) {
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
                  //min and max for x and y axis
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
                      color: Colors.blue,
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
