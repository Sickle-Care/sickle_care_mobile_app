import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sickle_cell_app/models/daily_report.dart';
import 'package:sickle_cell_app/models/user.dart';
import 'package:sickle_cell_app/providers/dailyReport_provider.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';
import 'package:sickle_cell_app/services/daily_record_service.dart';

class PatientRecordScreen extends ConsumerStatefulWidget {
  const PatientRecordScreen({super.key, required this.patient});

  final User patient;

  @override
  ConsumerState<PatientRecordScreen> createState() =>
      _PatientRecordScreenState();
}

class _PatientRecordScreenState extends ConsumerState<PatientRecordScreen> {
  DateTime _selectedDate = DateTime.now().toUtc().subtract(Duration(days: 1));
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      _getDailyReport();
    });
  }

  void _getDailyReport() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

    try {
      DailyRecordService dailyRecordService = DailyRecordService();
      var response = await dailyRecordService.getDailyReportByUserId(
          widget.patient.userId, formattedDate);
      if (response != null) {
        ref.read(dailyReportProvider.notifier).setRecord(response);
        print("daily report details ${response.toJson()}");
      } else {
        ref.read(dailyReportProvider.notifier).setRecord(DailyReport(
              userId: response!.userId,
              date: response.date,
              recordId: response.recordId,
              reportId: response.reportId,
              patientId: response.patientId,
              waterIntake: WaterIntake(percentage: 0),
              diet: Diet(percentage: 0),
              sleep: Sleep(percentage: 0),
              medicine: Medicine(percentage: 0),
            ));
        showErrorSnackbar("No daily report found", context);
      }
    } catch (e) {
      showErrorSnackbar("An error occurred: $e", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = ref.watch(dailyReportProvider);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("PATIENT RECORD"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 2, color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  padding: EdgeInsets.all(24),
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image(
                                    image: AssetImage(
                                        'assets/images/propic_placeholder.jpg.avif')),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${widget.patient.firstName} ${widget.patient.lastName}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.patient.sickleCellType!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 6 / 3,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 25,
                          children: [
                            ProfileGridItem(
                                title: "Age",
                                value: widget.patient.age.toString()),
                            ProfileGridItem(
                                title: "Gender", value: widget.patient.gender!)
                          ],
                        ),
                        // ProfileGridItem(title: "Gender", value: "male"),
                        Container(
                          padding: EdgeInsets.all(20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black,
                          ),
                          child: Text(
                            widget.patient.email,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black,
                          ),
                          child: Text(
                            widget.patient.contactNumber,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 2, color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  height: height * 0.3,
                  padding: EdgeInsets.all(20),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      SingleGridItem(
                        icon: Icons.water_drop,
                        color: const Color.fromARGB(255, 135, 206, 235),
                        value:
                            "${report?.waterIntake?.percentage?.toStringAsFixed(0) ?? "0"}%",
                      ),
                      SingleGridItem(
                        icon: Icons.set_meal_outlined,
                        color: const Color.fromARGB(255, 162, 209, 73),
                        value:
                            "${report?.diet?.percentage?.toStringAsFixed(0) ?? "0"}%",
                      ),
                      SingleGridItem(
                        icon: Icons.bed,
                        color: const Color.fromARGB(255, 44, 62, 80),
                        value:
                            "${report?.sleep?.percentage?.toStringAsFixed(0) ?? "0"}%",
                      ),
                      SingleGridItem(
                        icon: Icons.medication,
                        color: const Color.fromARGB(255, 203, 170, 203),
                        value:
                            "${report?.medicine?.percentage?.toStringAsFixed(0) ?? "0"}%",
                      ),
                    ],
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

class ProfileGridItem extends StatelessWidget {
  const ProfileGridItem({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Text(
        "$title: $value",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class SingleGridItem extends StatelessWidget {
  const SingleGridItem({
    super.key,
    required this.icon,
    required this.color,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
