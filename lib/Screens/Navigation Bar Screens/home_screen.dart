import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ─────────────────────────────────
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(
                      "assets/images/1.png",
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Bienvenu\n",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "Maryam Fatima!",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 66,
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Text(
                "Tableau de bord",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _statCard("Nombre total d'étudiants", "250"),
                  const SizedBox(width: 10),
                  _statCard("Étudiants actifs", "200"),
                ],
              ),
              const SizedBox(height: 10),
              _graphCard("Score moyen au quiz", "85%", _lineChart()),
              const SizedBox(height: 10),
              _barChartCard(),
              const SizedBox(height: 10),
              _graphCard("Score des quiz au fil du temps", "75%", _lineChart(),
                  suffix: "-2 %"),
              const SizedBox(height: 20),
              const Text(
                "Activité récente",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              _activityTile(
                  "Maryam Fatima", "Quiz 1 terminé", "assets/images/1.png"),
              _activityTile("Maryam Fatima", "Quiz 1 terminé",
                  "assets/images/Rectangle_2340.png"),
              _activityTile("Maryam Fatima", "Quiz 1 terminé",
                  "assets/images/Rectangle_2342.png"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _boxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _graphCard(String title, String value, Widget chart,
      {String? suffix}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (suffix != null)
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Last 30 Days ",
                        style: const TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: suffix,
                        style: const TextStyle(color: Color(0xFFCC9900)),
                      ),
                    ],
                  ),
                )
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(height: 80, child: chart),
        ],
      ),
    );
  }

  Widget _barChartCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Participation des étudiants"),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("80%",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Last 7 Days ",
                      style: const TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: "+5 %",
                      style: const TextStyle(color: Color(0xFFCC9900)),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) => Text(
                        [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thur',
                          'Sat',
                          'Sun'
                        ][value.toInt()],
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ),
                barGroups: List.generate(6, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: 8,
                        width: 12,
                        color: const Color(0xFFF7DF9F),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lineChart() {
    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: const Color(0xFFF7DF9F),
            barWidth: 3,
            belowBarData: BarAreaData(show: false),
            spots: const [
              FlSpot(0, 3),
              FlSpot(1, 5),
              FlSpot(2, 4),
              FlSpot(3, 6),
              FlSpot(4, 5),
            ],
          ),
        ],
      ),
    );
  }

  Widget _activityTile(String name, String action, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: "$name\n",
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: action,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          const Text("2 h Ago", style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    );
  }
}
