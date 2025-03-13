import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sickle_cell_app/models/doctor_request.dart';
import 'package:sickle_cell_app/providers/request_provider.dart';
import 'package:sickle_cell_app/providers/user_provider.dart';
import 'package:sickle_cell_app/resources/async_handler.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';

class PatientRequestListScreen extends ConsumerStatefulWidget {
  const PatientRequestListScreen({super.key});

  @override
  ConsumerState<PatientRequestListScreen> createState() =>
      _PatientRequestListScreenState();
}

class _PatientRequestListScreenState
    extends ConsumerState<PatientRequestListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Delay provider modification using Future.microtask
    Future.microtask(() {
      _getRequests();
    });
  }

  void _getRequests() async {
    var doctor = ref.watch(userProvider);
    try {
      ref
          .read(requestProvider.notifier)
          .fetchRequestsByDoctorId(doctor!.doctorId!);
    } catch (e) {
      showErrorSnackbar("Something went wrong!", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final requests = ref.watch(requestProvider);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("PATIENT REQUEST LIST"),
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
          padding: EdgeInsets.all(10),
          child: AsyncHandler<List<DoctorRequest>>(
            asyncValue: requests,
            onData: (context, requests) {
              if (requests.isEmpty) {
                return Center(
                  child: Text(
                    "No requests available",
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
                  ...requests.map(
                    (request) => Column(
                      children: [
                        SinglePatientRow(
                          name: request.patientName,
                          onAccepted: () {
                            ref
                                .read(requestProvider.notifier)
                                .acceptRequest(request.requestId!);
                          },
                          onRejected: () {
                            ref
                                .read(requestProvider.notifier)
                                .declineRequest(request.requestId!);
                          },
                          onInfo: () {},
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
    required this.onAccepted,
    required this.onRejected,
    required this.onInfo,
  });

  final String name;
  final Function() onAccepted;
  final Function() onRejected;
  final Function() onInfo;

  @override
  State createState() => _SinglePatientRowState();
}

class _SinglePatientRowState extends State<SinglePatientRow> {
  @override
  Widget build(BuildContext context) {
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
            horizontal: width * 0.08, vertical: height * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  widget.name,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                // SizedBox(
                //   width: 5,
                // ),
                // InkWell(
                //   child: Icon(
                //     Icons.info_outline,
                //     size: 20,
                //     color: Colors.blue,
                //   ),
                // ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: widget.onRejected,
                  child: Icon(
                    Icons.close,
                    size: 38,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: widget.onAccepted,
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 40,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
