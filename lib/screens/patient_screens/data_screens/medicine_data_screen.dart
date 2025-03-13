import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sickle_cell_app/models/health_record.dart';
import 'package:sickle_cell_app/providers/healthRecord_provider.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';
import 'package:sickle_cell_app/services/healthrecord_service.dart';
import 'package:sickle_cell_app/widgets/button.dart';

class MedicineDataScreen extends ConsumerStatefulWidget {
  const MedicineDataScreen({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  ConsumerState<MedicineDataScreen> createState() => _MedicineDataScreenState();
}

class _MedicineDataScreenState extends ConsumerState<MedicineDataScreen> {
  // Store the medicine data in a state variable
  late Medicine medicine;

  @override
  void initState() {
    super.initState();
    final healthRecord = ref.read(healthRecordProvider);
    medicine = healthRecord!.medicine;
  }

  void updateMedicineStatus(String time, int index, bool isTaken) {
    setState(() {
      switch (time) {
        case 'morning':
          medicine.morning[index] =
              medicine.morning[index].copyWith(isTaken: isTaken);
          break;
        case 'day':
          medicine.day[index] = medicine.day[index].copyWith(isTaken: isTaken);
          break;
        case 'night':
          medicine.night[index] =
              medicine.night[index].copyWith(isTaken: isTaken);
          break;
      }
    });
  }

  void _updateMedicineDetails(HealthRecord healthRecord) async {
    try {
      Medicine updatedMedicine = healthRecord.medicine.copyWith(
          morning: medicine.morning, day: medicine.day, night: medicine.night);
      HealthrecordService healthRecordService = HealthrecordService();
      var response = await healthRecordService.updateMedicine(
          updatedMedicine, healthRecord.recordId);
      if (response.recordId != "") {
        ref.read(healthRecordProvider.notifier).setRecord(response);
        showSuccessSnackbar("Successfully updated medicine data", context);
      } else {
        showErrorSnackbar("Failed to update medicine data", context);
      }
    } catch (e) {
      showErrorSnackbar("Failed to update medicine data", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final healthRecord = ref.watch(healthRecordProvider);
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("MEDICINE GOAL DETAILS"),
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
              Text(
                "Date: $formattedDate",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Morning Medicines
              _buildMedicineSection("Morning", medicine.morning),
              SizedBox(height: 20),
              // Day Medicines
              _buildMedicineSection("Day", medicine.day),
              SizedBox(height: 20),
              // Night Medicines
              _buildMedicineSection("Night", medicine.night),
              SizedBox(height: 20),
              MyButton(
                onPressed: () {
                  _updateMedicineDetails(healthRecord!);
                },
                buttonText: "Update Medicine Details",
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicineSection(String title, List<MedicineDose> medicines) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side:
            BorderSide(width: 2, color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.08, vertical: height * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 20),
            // Render each medicine item
            for (var i = 0; i < medicines.length; i++)
              SingleMedicineData(
                name: medicines[i].name,
                isTaken: medicines[i].isTaken,
                onChanged: (bool newValue) {
                  updateMedicineStatus(title.toLowerCase(), i, newValue);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class SingleMedicineData extends StatefulWidget {
  const SingleMedicineData({
    super.key,
    required this.name,
    required this.isTaken,
    required this.onChanged, // Callback to notify parent
  });

  final String name;
  final bool isTaken;
  final Function(bool) onChanged; // Callback function with new value

  @override
  _SingleMedicineDataState createState() => _SingleMedicineDataState();
}

class _SingleMedicineDataState extends State<SingleMedicineData> {
  late bool isTaken;

  @override
  void initState() {
    super.initState();
    isTaken = widget.isTaken;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.name,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              isTaken = !isTaken;
            });
            // Notify the parent about the state change
            widget.onChanged(isTaken);
          },
          child: Icon(
            isTaken ? Icons.check_circle : Icons.circle_outlined,
            color: isTaken ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}
