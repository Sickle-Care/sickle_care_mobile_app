import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sickle_cell_app/screens/doctor_screens/patient_request_list_screen.dart';
import 'package:sickle_cell_app/screens/doctor_screens/patient_list_screen.dart';
import 'package:sickle_cell_app/screens/doctor_screens/session_chat_screens/session_chat_list_screen_doctor.dart';
import 'package:sickle_cell_app/screens/doctor_screens/session_screens/session_list_screen.dart';

class HomeScreenDoctor extends ConsumerStatefulWidget {
  const HomeScreenDoctor({super.key, required this.firstName});

  final String firstName;

  @override
  ConsumerState<HomeScreenDoctor> createState() => _HomeScreenDoctorState();
}

class _HomeScreenDoctorState extends ConsumerState<HomeScreenDoctor> {
  void _selectType(BuildContext context, String goalType) {
    if (goalType == 'Patients') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => PatientListScreen(),
        ),
      );
    }
    if (goalType == 'Sessions') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => SessionListScreen()),
      );
    }
    if (goalType == 'Chats') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => SessionChatListScreenDoctor(),
        ),
      );
    }
    if (goalType == 'Requests') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => PatientRequestListScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: width * 0.06, vertical: 0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                // gradient: LinearGradient(
                //   colors: [
                //     Theme.of(context).colorScheme.primary,
                //     // Theme.of(context).colorScheme.secondary
                //   ],
                // ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(width * 0.01),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome Back, Dr.${widget.firstName}!',
                            style: GoogleFonts.patrickHand(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Strength in every cell, courage in every challenge.',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w100,
                              fontSize: 17,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: height * 0.72,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Your Dashboard",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      // shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10),
                      children: [
                        GoalItem(
                          title: "Patients",
                          icon: Icons.group,
                          onTapGoal: () {
                            _selectType(context, "Patients");
                          },
                        ),
                        GoalItem(
                          title: "Sessions",
                          icon: Icons.calendar_month,
                          onTapGoal: () {
                            _selectType(context, "Sessions");
                          },
                        ),
                        GoalItem(
                          title: "Session Chats",
                          icon: Icons.chat,
                          onTapGoal: () {
                            _selectType(context, "Chats");
                          },
                        ),
                        GoalItem(
                          title: "Patient Requests",
                          icon: Icons.person_add,
                          onTapGoal: () {
                            _selectType(context, "Requests");
                          },
                        ),
                        SizedBox(
                          height: 80,
                        )
                        // Add more habits as needed
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GoalItem extends StatelessWidget {
  const GoalItem(
      {super.key,
      required this.title,
      required this.icon,
      // required this.color,
      required this.onTapGoal});

  final String title;
  final IconData icon;
  // final Color color;
  final void Function() onTapGoal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapGoal,
      child: Container(
        height: 90,
        // padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        padding: EdgeInsets.only(top: 15, left: 10, right: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 3,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        margin: EdgeInsets.only(bottom: 16.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 30,
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
      ),
    );
  }
}
