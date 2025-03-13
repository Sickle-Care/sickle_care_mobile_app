import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sickle_cell_app/providers/healthRecord_provider.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';
import 'package:sickle_cell_app/screens/patient_screens/data_screens/diet_data_screen.dart';
import 'package:sickle_cell_app/screens/patient_screens/data_screens/medicine_data_screen.dart';
import 'package:sickle_cell_app/screens/patient_screens/data_screens/sleep_data_screen.dart';
import 'package:sickle_cell_app/screens/patient_screens/data_screens/water_data_screen.dart';
import 'package:sickle_cell_app/screens/patient_screens/data_screens/alcohol_data_screen.dart';
import 'package:sickle_cell_app/services/healthrecord_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.firstName});

  final String firstName;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime _selectedDate = DateTime.now().toUtc();

  @override
  void initState() {
    super.initState();
    _getHealthDetails();
  }

  void _getHealthDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    try {
      HealthrecordService userService = HealthrecordService();
      var response = await userService.getHealthDetails(userId!, formattedDate);
      if (response != null) {
        ref.read(healthRecordProvider.notifier).setRecord(response);
        print("healthrecord details ${response.toJson()}");
      } else {
        showErrorSnackbar("No health record found", context);
      }
    } catch (e) {
      showErrorSnackbar("No health record found", context);
    }
  }

  void _selectType(BuildContext context, String goalType) {
    if (goalType == 'Water') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => WaterDataScreen(
            selectedDate: _selectedDate,
          ),
        ),
      );
    }
    if (goalType == 'Alcohol') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => AlcoholDataScreen(
            selectedDate: _selectedDate,
          ),
        ),
      );
    }
    if (goalType == 'Sleep') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => SleepDataScreen(
            selectedDate: _selectedDate,
          ),
        ),
      );
    }
    if (goalType == 'Medicine') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => MedicineDataScreen(
            selectedDate: _selectedDate,
          ),
        ),
      );
    }
    if (goalType == 'Diet') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => DietDataScreen(
            selectedDate: _selectedDate,
          ),
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
                // color: Theme.of(context).colorScheme.secondary,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary
                  ],
                ),
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
                          Image.asset(
                            'assets/images/bot.png',
                            height: 120,
                          ),
                          Text(
                            'Hello, ${widget.firstName}!',
                            style: GoogleFonts.patrickHand(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Truth be told, at the end of the day, equality is just a fantasy',
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
              height: height * 0.68,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 12,
                      left: 5,
                      right: 5,
                    ),
                    child: EasyDateTimeLine(
                      initialDate: DateTime.now(),
                      dayProps: const EasyDayProps(
                        dayStructure: DayStructure.dayStrDayNum,
                        height: 80.0,
                        width: 56.0,
                        activeDayStyle: DayStyle(
                          dayNumStyle: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        disabledDayStyle: DayStyle(
                          dayNumStyle: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color:
                                Colors.grey, // Grey out inactive (future) dates
                          ),
                        ),
                      ),
                      headerProps: const EasyHeaderProps(
                        dateFormatter: DateFormatter.fullDateMonthAsStrDY(),
                        monthPickerType: MonthPickerType.switcher,
                      ),
                      onDateChange: (selectedDate) {
                        if (selectedDate
                            .isBefore(DateTime.now().add(Duration(days: 1)))) {
                          setState(() {
                            _selectedDate = selectedDate;
                          });
                        }
                      },
                      disabledDates: List.generate(
                        365, // Disable future dates for the next 1 year
                        (index) =>
                            DateTime.now().add(Duration(days: index + 1)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      // shrinkWrap: true,
                      padding: EdgeInsets.only(top: 30),
                      children: [
                        GoalItem(
                          color: const Color.fromARGB(255, 135, 206, 235),
                          title: "Water",
                          icon: Icons.water_drop,
                          onTapGoal: () {
                            _selectType(context, "Water");
                          },
                        ),
                        GoalItem(
                          color: const Color.fromARGB(255, 162, 209, 73),
                          title: "Diet",
                          icon: Icons.set_meal_outlined,
                          onTapGoal: () {
                            _selectType(context, "Diet");
                          },
                        ),
                        GoalItem(
                          color: const Color.fromARGB(255, 44, 62, 80),
                          title: "Sleep",
                          icon: Icons.bed,
                          onTapGoal: () {
                            _selectType(context, "Sleep");
                          },
                        ),
                        GoalItem(
                          color: const Color.fromARGB(255, 203, 170, 203),
                          title: "Medicine",
                          icon: Icons.medication,
                          onTapGoal: () {
                            _selectType(context, "Medicine");
                          },
                        ),
                        GoalItem(
                          color: const Color.fromARGB(255, 178, 58, 72),
                          title: "Alcohol",
                          icon: Icons.wine_bar,
                          onTapGoal: () {
                            _selectType(context, "Alcohol");
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
      required this.color,
      required this.onTapGoal});

  final String title;
  final IconData icon;
  final Color color;
  final void Function() onTapGoal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapGoal,
      child: Container(
        height: 100,
        padding: EdgeInsets.fromLTRB(5, 12, 5, 10),
        decoration: BoxDecoration(
          color: color,
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
          subtitle: Text(
            "Click to see $title goal progress",
            style: Theme.of(context)
                .textTheme
                .bodySmall!
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
