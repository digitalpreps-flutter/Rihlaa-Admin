import 'package:flutter/material.dart';
import 'package:rihalaah_app_admin/Screens/Navigation%20Bar%20Screens/schedule_new_class.dart';

class LiveClasses extends StatefulWidget {
  const LiveClasses({super.key});

  @override
  State<LiveClasses> createState() => _LiveClassesState();
}

class _LiveClassesState extends State<LiveClasses> {
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title ─────────────────────────────────────────────
              const Text(
                'Cours en direct à venir',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // ── Live Class Card ──────────────────────────────────
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    // Thumbnail Image
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

                    // Title & Time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Session Hadith en direct",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Prochaine séance : Demain 19h00",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFFCC9900),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Join Button
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        side: const BorderSide(color: Color(0xFF7D948D)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text("Rejoindre", style: TextStyle(
                        color: Color(0xFF7D948D)
                      ),),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              const Divider(),

              // ── Schedule New Class Button ────────────────────────
              const SizedBox(height: 30),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ScheduleNewClassScreen()));
                  },
                  child: const Text(
                    'Programmer un nouveau cours',
                    style: TextStyle(fontSize: 18,color: Colors.white),
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