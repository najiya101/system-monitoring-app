import 'package:flutter/material.dart';
import 'package:system_monitoring_app/Pages/cpu.dart';
import 'package:system_monitoring_app/Pages/disk.dart';
import 'package:system_monitoring_app/Pages/memory.dart';
import 'package:system_monitoring_app/Pages/settings.dart';
import 'package:system_monitoring_app/widgets/widgets.dart';
import 'dart:async'; //timer
import 'connect.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //variables
  double cpuusage = 0.0;
  double memoryusage = 0.0;
  double diskusage = 0.0;
 Timer? timer;
  @override
  void initState() {
    super.initState();
    fetchdata();
  }
  void fetchdata(){
    timer = Timer.periodic(Duration(seconds: 5), (_timer)async{
      
        final data = await datas.fetchSystemMetrics();

        setState(() {
          //update cpu
         cpuusage = (data['cpu_usage_percentage'] as num).toDouble();
        //calculate memory usage
        double totalMemory = (data['memory_usage']['total_mb'] as num).toDouble();
        double usedMemory = (data['memory_usage']['used_mb'] as num).toDouble();
        memoryusage = (usedMemory / totalMemory) * 100;
        //calcualte disk usage
        double totalDisk = (data['disk_usage']['total_mb'] as num).toDouble();
        double usedDisk = (data['disk_usage']['used_mb'] as num).toDouble();
        diskusage = (usedDisk / totalDisk) * 100;
        });
      
    });
  }@override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("Monitoring App"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();  //popup menu item list
            },
          ),
        ],
      ),
      body: Center(
        child: SafeArea(
            child: LayoutBuilder(
            builder: (context, constraints) {
              double chartSize = constraints.maxWidth * 0.4 ;//calculate chart size
          return SingleChildScrollView(
          child: Column(
            children: [
              //display chart
              datachart("CPU",cpuusage , Colors.red, Colors.redAccent.shade100, size:chartSize,),
              SizedBox(height: 20,),
              datachart("Memory",memoryusage , Colors.green, Colors.greenAccent.shade100, size:chartSize),
              SizedBox(height: 20,),
               datachart("Disk",diskusage , Colors.blue, Colors.blueAccent.shade100, size: chartSize),
            ],
          ),
        );})),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => cpupage()
                  ),
                );
              },
              icon: Icon(Icons.circle, size: 12, color: Colors.red),
              label: Text('CPU',style: TextStyle(color: Colors.black),),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => memorypage()
                ),
              );
              },
              icon: Icon(Icons.circle, size: 12, color: Colors.green),
              label: Text('Memory',style: TextStyle(color: Colors.black),),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => diskpage()
                ),
              );
              },
              icon: Icon(Icons.circle, size: 12, color: Colors.blue),
              label: Text('Disk',style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
  
}