import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'connect.dart';

class cpupage extends StatefulWidget {
  const cpupage({super.key});

  @override
  State<cpupage> createState() => _cpuPageState();
}

class _cpuPageState extends State<cpupage> {
  List<FlSpot> dataPoints = [];//store data point for line chart
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  void fetchdata() {
    timer = Timer.periodic(Duration(seconds: 5), (_timer) async {
        //fetch cpu usage
        final data = await datas.fetchSystemMetrics();

        setState(() {
          double cpuusage = (data['cpu_usage_percentage'] as num).toDouble();
          DateTime now = DateTime.now();//get current time
          dataPoints.add(FlSpot(now.millisecondsSinceEpoch.toDouble(), cpuusage));//add new data point with current time and cpu usage

          if (dataPoints.length > 20) {//latest 20
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
        title: Text('CPU Usage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: LineChart(
                LineChartData(
                  //show grid lines
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 10,  
                        reservedSize: 40,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          //readable time format in x axis
                          DateTime time = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                          return Text("${time.minute}:${time.second}");
                        },
                      ),
                      
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  //set the min and max values for x and y axis
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
                      color: Colors.red,
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
