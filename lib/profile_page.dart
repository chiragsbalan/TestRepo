import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart'; // Import the package

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String name = 'Lena Geo';
  final String rollNumber = '2241139';
  final String classAndSection = 'BCA B';
  final String phone = '+91 1234567890';
  final String email = 'lena.geo@bca.christuniversity.in';
  final double cgpa = 3.85;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final List<FlSpot> academicProgress = [
    FlSpot(1, 78.67),
    FlSpot(2, 84.27),
    FlSpot(3, 74.53),
    FlSpot(4, 89.63),
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImagePath', pickedFile.path);
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profileImagePath');
    if (imagePath != null) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : NetworkImage('https://via.placeholder.com/150')
                            as ImageProvider,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  'Roll Number: $rollNumber',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Center(
                child: Text(
                  'Class & Section: $classAndSection',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 16),
              // Add the CGPA ListTile
              ListTile(
                leading: Icon(Icons.school, color: Colors.white),
                title: Text(
                  'CGPA: $cgpa',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                leading: Icon(Icons.phone, color: Colors.white),
                title: Text(phone, style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                leading: Icon(Icons.email, color: Colors.white),
                title: AutoSizeText(
                  email,
                  style: TextStyle(color: Colors.white),
                  maxLines: 1, // Ensure it stays in one line
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Academic Progression',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameWidget: Text(
                          'Semester',
                          style: TextStyle(color: Colors.white),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 1:
                              case 2:
                              case 3:
                              case 4:
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                );
                              default:
                                return Text('');
                            }
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(color: Colors.white, width: 1),
                        bottom: BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                    minX: 1,
                    maxX: academicProgress.length.toDouble(),
                    minY: 50,
                    maxY: 100,
                    lineBarsData: [
                      LineChartBarData(
                        spots: academicProgress,
                        isCurved: false,
                        color: Colors.white,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            final passed = spot.y >= 40;
                            return FlDotCirclePainter(
                              radius: 4,
                              color: passed ? Colors.green : Colors.red,
                              strokeWidth: 1,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.white.withOpacity(0.2),
                          cutOffY: 0,
                          applyCutOffY: true,
                        ),
                        aboveBarData: BarAreaData(
                          show: false,
                        ),
                        showingIndicators: List<int>.generate(
                            academicProgress.length, (index) => index),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((touchedSpot) {
                            final textStyle = TextStyle(
                              color: touchedSpot.y >= 40
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            );
                            return LineTooltipItem(
                              '${academicProgress[touchedSpot.spotIndex].y.toString()}',
                              textStyle,
                            );
                          }).toList();
                        },
                      ),
                      touchCallback:
                          (FlTouchEvent event, LineTouchResponse? response) {},
                      handleBuiltInTouches: true,
                      getTouchedSpotIndicator: (barData, spotIndexes) {
                        return spotIndexes.map((index) {
                          final spot = barData.spots[index];
                          final passed = spot.y >= 40;
                          final color = passed ? Colors.green : Colors.red;
                          return TouchedSpotIndicatorData(
                            FlLine(color: color, strokeWidth: 2),
                            FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 6,
                                  color: color,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
