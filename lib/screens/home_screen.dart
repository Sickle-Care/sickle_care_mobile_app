import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sickle_cell_app/models/goal.dart';
import 'package:sickle_cell_app/screens/single_data_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.firstName});

  final String firstName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();

  void _selectType(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => SingleDataScreen()));
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
                          goal: Goal(
                              id: "1",
                              title: "Water",
                              goal: 2,
                              goalCompleted: 1,
                              goalCompletedPercentage: 50),
                          onTapGoal: () {
                            _selectType(context);
                          },
                        ),
                        GoalItem(
                          color: const Color.fromARGB(255, 162, 209, 73),
                          goal: Goal(
                              id: "2",
                              title: "Diet",
                              goal: 2,
                              goalCompleted: 1,
                              goalCompletedPercentage: 50),
                          onTapGoal: () {
                            _selectType(context);
                          },
                        ),
                        GoalItem(
                          color: const Color.fromARGB(255, 44, 62, 80),
                          goal: Goal(
                              id: "3",
                              title: "Sleep",
                              goal: 2,
                              goalCompleted: 1,
                              goalCompletedPercentage: 50),
                          onTapGoal: () {
                            _selectType(context);
                          },
                        ),
                        GoalItem(
                          color: const Color.fromARGB(255, 203, 170, 203),
                          goal: Goal(
                              id: "4",
                              title: "Medicine",
                              goal: 2,
                              goalCompleted: 1,
                              goalCompletedPercentage: 50),
                          onTapGoal: () {
                            _selectType(context);
                          },
                        ),
                        GoalItem(
                          color: const Color.fromARGB(255, 178, 58, 72),
                          goal: Goal(
                              id: "5",
                              title: "Alcohol",
                              goal: 2,
                              goalCompleted: 1,
                              goalCompletedPercentage: 50),
                          onTapGoal: () {
                            _selectType(context);
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
      required this.color,
      required this.goal,
      required this.onTapGoal});

  final Color color;
  final Goal goal;
  final void Function() onTapGoal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapGoal,
      child: Container(
        height: 90,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        margin: EdgeInsets.only(bottom: 16.0),
        child: ListTile(
          title: Text(
            goal.title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Click to see ${goal.title} goal progress",
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            "${goal.goalCompletedPercentage.toStringAsFixed(0)}%",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

