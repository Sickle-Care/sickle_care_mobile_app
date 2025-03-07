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

class AlcoholDataScreen extends ConsumerStatefulWidget {
  const AlcoholDataScreen({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  ConsumerState<AlcoholDataScreen> createState() => _AlcoholDataScreenState();
}

class _AlcoholDataScreenState extends ConsumerState<AlcoholDataScreen> {
  int _selectedGlasses = 0;
  final int _totalGlasses = 5;

  @override
  void initState() {
    super.initState();
    final healthRecord = ref.read(healthRecordProvider);
    if (healthRecord != null) {
      _selectedGlasses = healthRecord.alcoholConsumption!.shotCount;
    }
  }

  void updateAlchoholConsumption(HealthRecord healthRecord) async {
    try {
      AlcoholConsumption updatedAlchoholConsumption = healthRecord
          .alcoholConsumption!
          .copyWith(shotCount: _selectedGlasses, canCount: _totalGlasses);
      HealthrecordService healthRecordService = HealthrecordService();
      var response = await healthRecordService.updateAlchoholIntake(
          updatedAlchoholConsumption, healthRecord.recordId);
      if (response.recordId != null) {
        ref.read(healthRecordProvider.notifier).setRecord(response);
        showSuccessSnackbar(
            "Successfully updated alchohol consumption", context);
      } else {
        showErrorSnackbar("Failed to update alchohol consumption", context);
      }
    } catch (e) {
      showErrorSnackbar("Failed to update alchohol consumption", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final healthRecord = ref.watch(healthRecordProvider);
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("ALCOHOL GOAL DETAILS"),
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
                  percent: healthRecord!.alcoholPercentage,
                  center: Text(
                    healthRecord.alcoholPercentage.toStringAsFixed(0),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: const Color.fromARGB(255, 178, 58, 72),
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
                'Update Your Alcohol Intake Here',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Wrap(
                spacing: 1,
                children: List<Widget>.generate(
                  _totalGlasses,
                  (int index) {
                    // If the index is less than the selected number, show filled glass
                    // Otherwise, show empty glass
                    return Image.asset(
                      index < _selectedGlasses
                          ? 'assets/images/filled_wine_glass.png'
                          : 'assets/images/empty_wine_glass.png',
                      width: 60,
                      height: 100,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Alcohol is bad for yourself',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.blueGrey),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: width * 0.5,
                child: DropdownButton<int>(
                  value: _selectedGlasses,
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
                      _selectedGlasses = newValue!;
                    });
                    // _updateUserAlcoholIntake(newValue!);
                  },
                  items: List<DropdownMenuItem<int>>.generate(
                    _totalGlasses + 1, // Options from 0 to 10
                    (int index) => DropdownMenuItem<int>(
                      value: index,
                      child: Text('$index glasses'),
                    ),
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
                        updateAlchoholConsumption(healthRecord);
                      },
                      buttonText: "Update")),
            ],
          ),
        ),
      ),
    );
  }
}
