import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sickle_cell_app/resources/async_handler.dart';
import 'package:sickle_cell_app/models/doctor_request.dart';
import 'package:sickle_cell_app/models/user.dart';
import 'package:sickle_cell_app/providers/doctor_provider.dart';
import 'package:sickle_cell_app/providers/user_provider.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';
import 'package:sickle_cell_app/services/doctor_request_service.dart';

class DoctorListScreen extends ConsumerStatefulWidget {
  const DoctorListScreen({super.key});

  @override
  ConsumerState<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends ConsumerState<DoctorListScreen> {
  void createRequest(String doctorId, User user) async {
    try {
      if (user.patientId == null) {
        print("Patient ID is missing");
        return;
      }

      final DoctorRequest request = DoctorRequest(
        requestId: "",
        doctorId: doctorId,
        patientId: user.patientId ?? "",
        patientName: "${user.firstName} ${user.lastName}",
        date: DateTime.now(),
        isAccepted: null,
        docNote: null,
        patientNote: null,
      );
      DoctorRequestService doctorRequestService = DoctorRequestService();
      var response = await doctorRequestService.createRequest(request);
      if (response.requestId != null) {
        showSuccessSnackbar("Successfully sent the request", context);
      } else {
        showErrorSnackbar("Failed to send the request", context);
      }
    } catch (e) {
      showErrorSnackbar("Failed to send the request", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final doctors = ref.watch(doctorProvider);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("DOCTORS LIST"),
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
            asyncValue: doctors,
            onData: (context, doctors) {
              if (doctors.isEmpty) {
                return Center(
                  child: Text(
                    "No doctors available",
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
                  ...doctors.map(
                    (doctor) => Column(
                      children: [
                        SingleDoctorRow(
                          name: "${doctor.firstName} ${doctor.lastName}",
                          onChanged: () {
                            createRequest(doctor.doctorId!, user!);
                            print("onChanged");
                          },
                        ),
                        SizedBox(height: 5),
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

class SingleDoctorRow extends StatefulWidget {
  const SingleDoctorRow({
    super.key,
    required this.name,
    required this.onChanged,
  });

  final String name;
  final Function() onChanged;

  @override
  State createState() => _SingleDoctorRowState();
}

class _SingleDoctorRowState extends State<SingleDoctorRow> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 2, color: Colors.black),
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
            InkWell(
              onTap: widget.onChanged,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child:
                      Text("Request", style: TextStyle(color: Colors.white))),
            ),
          ],
        ),
      ),
    );
  }
}
