import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sickle_cell_app/models/health_record.dart';
import 'package:sickle_cell_app/providers/healthRecord_provider.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';
import 'package:sickle_cell_app/services/healthrecord_service.dart';
import 'package:sickle_cell_app/widgets/button.dart';

class SleepDataScreen extends ConsumerStatefulWidget {
  const SleepDataScreen({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  ConsumerState<SleepDataScreen> createState() => _SleepDataScreenState();
}

class _SleepDataScreenState extends ConsumerState<SleepDataScreen> {
  final sleepQualityController = TextEditingController();
  int _selectedHours = 0;
  final int _totalHours = 8;

  @override
  void initState() {
    super.initState();
    final healthRecord = ref.read(healthRecordProvider);
    if (healthRecord != null) {
      _selectedHours = healthRecord.sleep!.hours;
      sleepQualityController.text = healthRecord.sleep!.quality;
    }
  }

  void updateWaterIntake(HealthRecord healthRecord) async {
    try {
      Sleep updatedSleep = healthRecord.sleep!.copyWith(
          hours: _selectedHours, quality: sleepQualityController.text);
      HealthrecordService healthRecordService = HealthrecordService();
      var response = await healthRecordService.updateSleep(
          updatedSleep, healthRecord.recordId);
      if (response.recordId != "") {
        ref.read(healthRecordProvider.notifier).setRecord(response);
        showSuccessSnackbar("Successfully updated sleep", context);
      } else {
        showErrorSnackbar("Failed to update sleep", context);
      }
    } catch (e) {
      showErrorSnackbar("Failed to update sleep", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final healthRecord = ref.watch(healthRecordProvider);
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("SLEEP GOAL DETAILS"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: CircularPercentIndicator(
                  radius: 100,
                  lineWidth: 13,
                  animation: true,
                  percent: healthRecord!.sleepPercentage / 100,
                  center: Text(
                    "${healthRecord.sleepPercentage.toStringAsFixed(0)} %",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: const Color.fromARGB(255, 44, 62, 80),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "Date: $formattedDate",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'Update Your Sleep Hours Here',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '$_selectedHours Hours',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: width * 0.5,
                child: DropdownButton<int>(
                  value: _selectedHours,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: HexColor("#8d8d8d"),
                  ),
                  isExpanded: true,
                  underline: Container(
                    height: 2,
                    color: HexColor("#ffffff"),
                  ),
                  iconSize: 30,
                  borderRadius: BorderRadius.circular(20),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedHours = newValue!;
                    });
                    // _updateUserSleepIntake(newValue!);
                  },
                  items: List<DropdownMenuItem<int>>.generate(
                    _totalHours + 1,
                    (int index) => DropdownMenuItem<int>(
                      value: index,
                      child: Text('$index Hours'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: width * 0.6,
                child: TextField(
                  controller: sleepQualityController,
                  keyboardType: TextInputType.text,
                  cursorColor: HexColor("#4f4f4f"),
                  decoration: InputDecoration(
                    hintText: "Refreshed, Tired, etc",
                    fillColor: HexColor("#f0f3f1"),
                    contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 15,
                          color: HexColor("#8d8d8d"),
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: width * 0.6,
                child: MyButton(
                    onPressed: () {
                      updateWaterIntake(healthRecord);
                    },
                    buttonText: "Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
