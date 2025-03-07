import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sickle_cell_app/screens/patient_screens/data_screens/medicine_data_screen.dart';
import 'package:sickle_cell_app/screens/patient_screens/data_screens/sleep_data_screen.dart';
import 'package:sickle_cell_app/screens/patient_screens/data_screens/water_data_screen.dart';
import 'package:sickle_cell_app/screens/patient_screens/data_screens/alcohol_data_screen.dart';
import 'package:sickle_cell_app/screens/doctor_screens/patient_list_screen.dart';
import 'package:sickle_cell_app/screens/doctor_screens/session_list_screen.dart';

class HomeScreenDoctor extends ConsumerStatefulWidget {
  const HomeScreenDoctor({super.key, required this.firstName});

  final String firstName;

  @override
  ConsumerState<HomeScreenDoctor> createState() => _HomeScreenDoctorState();
}

class _HomeScreenDoctorState extends ConsumerState<HomeScreenDoctor> {
  // @override
  // void initState() {
  //   super.initState();
  //   _getHealthDetails();
  // }

  // void _getHealthDetails() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userId = prefs.getString('userId');
  //   String formattedDate =
  //       "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
  //   try {
  //     HealthrecordService userService = HealthrecordService();
  //     var response = await userService.getHealthDetails(userId!, formattedDate);
  //     print("healthrecord details $response");
  //     if (response != null) {
  //       ref.read(healthRecordProvider.notifier).setRecord(response);
  //       print("healthrecord details $response");
  //     }
  //   } catch (e) {
  //     showErrorSnackbar("An error occurred: $e", context);
  //   }
  // }

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
    //   if (goalType == 'Sleep') {
    //     Navigator.of(context).push(
    //       MaterialPageRoute(
    //         builder: (ctx) => SleepDataScreen(
    //           selectedDate: _selectedDate,
    //         ),
    //       ),
    //     );
    //   }
    //   if (goalType == 'Medicine') {
    //     Navigator.of(context).push(
    //       MaterialPageRoute(
    //         builder: (ctx) => MedicineDataScreen(
    //           selectedDate: _selectedDate,
    //         ),
    //       ),
    //     );
    //   }
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
                          title: "Chat",
                          icon: Icons.chat,
                          onTapGoal: () {
                            // _selectType(context, "Sleep");
                          },
                        ),
                        GoalItem(
                          // color: const Color.fromARGB(255, 203, 170, 203),
                          title: "Medicine",
                          icon: Icons.medication,
                          onTapGoal: () {
                            // _selectType(context, "Medicine");
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
