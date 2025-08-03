import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rihalaah_app_admin/Screens/Navigation%20Bar%20Screens/schedule_new_class.dart';
import 'package:rihalaah_app_admin/helpers/session_helper.dart';
import 'package:rihalaah_app_admin/services/schedule_service.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveClasses extends StatefulWidget {
  const LiveClasses({super.key});

  @override
  State<LiveClasses> createState() => _LiveClassesState();
}

class _LiveClassesState extends State<LiveClasses> {
  List<dynamic> scheduledClasses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchScheduledClasses();
  }

  Future<void> fetchScheduledClasses() async {
    final data = await ScheduleService.getScheduledClasses();
    setState(() {
      scheduledClasses = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cours en direct à venir',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: scheduledClasses.length,
                        itemBuilder: (context, index) {
                          final classItem = scheduledClasses[index];
                          final topic = classItem['topic_name'] ?? '';
                          final startTimeStr = classItem['start_time'];
                          final joinUrl = classItem['zoom_join_url'];

                          DateTime startDateTime = DateTime.parse(startTimeStr);
                          String formattedTime =
                              DateFormat('HH:mm').format(startDateTime);
                          String subtitleText;

                          final now = DateTime.now();
                          final tomorrow = now.add(const Duration(days: 1));

                          if (startDateTime.year == tomorrow.year &&
                              startDateTime.month == tomorrow.month &&
                              startDateTime.day == tomorrow.day) {
                            subtitleText =
                                "Prochaine séance : Demain $formattedTime";
                          } else {
                            subtitleText =
                                "Prochaine séance : ${DateFormat('dd-MM-yyyy HH:mm').format(startDateTime)}";
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/images/Muhammad.png',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Session $topic en direct",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        subtitleText,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFFCC9900),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () async {
                                    final classId = classItem['id'];
                                    final zoomLink =
                                        await ScheduleService.joinClass(classId);

                                    if (zoomLink != null) {
                                      if (await canLaunchUrl(Uri.parse(zoomLink))) {
                                        await launchUrl(
                                          Uri.parse(zoomLink),
                                          mode: LaunchMode.externalApplication,
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Impossible d'ouvrir le lien")),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Impossible de rejoindre la session")),
                                      );
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    side: const BorderSide(
                                        color: Color(0xFF7D948D)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: const Text(
                                    "Rejoindre",
                                    style: TextStyle(color: Color(0xFF7D948D)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),
              // ── Add New Class Button ─────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7D948D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScheduleNewClassScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Programmer un nouveau cours',
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
