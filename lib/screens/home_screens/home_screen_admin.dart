import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sickle_cell_app/screens/admin_screens/admin_list_screen.dart';
import 'package:sickle_cell_app/screens/admin_screens/doctor_list_screen.dart';
import 'package:sickle_cell_app/screens/admin_screens/patient_list_screen.dart';
import 'package:sickle_cell_app/screens/patient_screens/blog_list_screen.dart';

class HomeScreenAdmin extends ConsumerStatefulWidget {
  const HomeScreenAdmin({super.key});
  @override
  ConsumerState<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends ConsumerState<HomeScreenAdmin> {
  void _selectType(BuildContext context, String goalType) {
    if (goalType == 'Patients') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => PatientListScreenAdmin(),
        ),
      );
    }
    if (goalType == 'Doctors') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => DoctorListScreenAdmin()),
      );
    }
    if (goalType == 'Admins') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => AdminListScreen(),
        ),
      );
    }
    if (goalType == 'Blogs') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => BlogListScreen(),
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
                            'Welcome Back, Admin!',
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
                          title: "Doctors",
                          icon: Icons.medical_services,
                          onTapGoal: () {
                            _selectType(context, "Doctors");
                          },
                        ),
                        GoalItem(
                          title: "Admins",
                          icon: Icons.admin_panel_settings,
                          onTapGoal: () {
                            _selectType(context, "Admins");
                          },
                        ),
                        GoalItem(
                          title: "Blogs Corner",
                          icon: Icons.my_library_books,
                          onTapGoal: () {
                            _selectType(context, "Blogs");
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
          color: const Color.fromARGB(255, 255, 103, 56),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        margin: EdgeInsets.only(bottom: 16.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
