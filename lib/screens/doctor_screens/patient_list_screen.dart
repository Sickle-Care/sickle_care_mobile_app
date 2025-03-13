import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sickle_cell_app/models/user.dart';
import 'package:sickle_cell_app/providers/patient_provider.dart';
import 'package:sickle_cell_app/providers/user_provider.dart';
import 'package:sickle_cell_app/resources/async_handler.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';
import 'package:sickle_cell_app/screens/doctor_screens/patient_record_screen.dart';

class PatientListScreen extends ConsumerStatefulWidget {
  const PatientListScreen({super.key});

  @override
  ConsumerState<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends ConsumerState<PatientListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Delay provider modification using Future.microtask
    Future.microtask(() {
      _getPatients();
    });
  }

  void _getPatients() async {
    final user = ref.watch(userProvider);
    try {
      ref.read(patientProvider.notifier).fetchPatientsByDoctorId(user!.doctorId!);
    } catch (e) {
      showErrorSnackbar("Failed to get patients", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(patientProvider);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("PATIENTS LIST"),
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
          child: AsyncHandler<List<User>>(
            asyncValue: patients,
            onData: (context, patients) {
              if (patients.isEmpty) {
                return Center(
                  child: Text(
                    "No patients available",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...patients.map(
                    (patient) => Column(
                      children: [
                        SinglePatientRow(
                          name: "${patient.firstName} ${patient.lastName}",
                          onChanged: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientRecordScreen(
                                  patient: patient,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class SinglePatientRow extends StatefulWidget {
  const SinglePatientRow({
    super.key,
    required this.name,
    required this.onChanged,
  });

  final String name;
  final Function() onChanged;

  @override
  State createState() => _SinglePatientRowState();
}

class _SinglePatientRowState extends State<SinglePatientRow> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: widget.onChanged,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 2, color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.08, vertical: height * 0.03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.name,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
