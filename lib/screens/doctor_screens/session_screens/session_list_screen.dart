import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:sickle_cell_app/models/session.dart';
import 'package:sickle_cell_app/providers/patient_provider.dart';
import 'package:sickle_cell_app/providers/session_provider.dart';
import 'package:sickle_cell_app/providers/user_provider.dart';
import 'package:sickle_cell_app/resources/async_handler.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';
import 'package:sickle_cell_app/screens/doctor_screens/session_screens/add_session_modal.dart';
import 'package:sickle_cell_app/services/session_service.dart';

class SessionListScreen extends ConsumerStatefulWidget {
  const SessionListScreen({super.key});

  @override
  ConsumerState<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends ConsumerState<SessionListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      _getPatients();
      _getSessions();
    });
  }

  void _getPatients() async {
    final user = ref.watch(userProvider);
    try {
      ref
          .read(patientProvider.notifier)
          .fetchPatientsByDoctorId(user!.doctorId!);
    } catch (e) {
      showErrorSnackbar("Failed to get patients", context);
    }
  }

  void _getSessions() async {
    final user = ref.watch(userProvider);
    try {
      ref
          .read(sessionProvider.notifier)
          .fetchSessionsByDoctorId(user!.doctorId!);
    } catch (e) {
      showErrorSnackbar("Failed to get patients", context);
    }
  }

  void _addSession() {
    final patientsAsync = ref.read(patientProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return patientsAsync.when(
          data: (patients) {
            return AddSessionModal(
              patients: patients,
              onAddSession: (session) async {
                print(session.toJson());
                try {
                  SessionService sessionService = SessionService();
                  final response = await sessionService.createSession(session);
                  if (response.sessionId != "") {
                    showSuccessSnackbar("Session added successfully", context);
                    _getSessions();
                  } else {
                    showErrorSnackbar("Failed to add session", context);
                  }
                } catch (e) {
                  showErrorSnackbar("Failed to add session", context);
                }
              },
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              Center(child: Text("Failed to load patients")),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(sessionProvider);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("UPCOMING SESSIONS"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addSession,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: AsyncHandler<List<Session>>(
            asyncValue: sessions,
            onData: (context, sessions) {
              if (sessions.isEmpty) {
                return Center(
                  child: Text(
                    "No sessions available",
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
                  ...sessions.map(
                    (session) => Column(
                      children: [
                        SingleSessionRow(
                          session: session,
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

class SingleSessionRow extends StatefulWidget {
  const SingleSessionRow({super.key, required this.session});

  final Session session;

  @override
  State createState() => _SingleSessionRowState();
}

class _SingleSessionRowState extends State<SingleSessionRow> {
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
            horizontal: width * 0.06, vertical: height * 0.02),
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('yyyy-MM-dd').format(widget.session.dateTime!),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 17, vertical: 5),
                decoration: BoxDecoration(
                  color: HexColor("#8d8d8d"),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  "Support Session with ${widget.session.patientName} - ${DateFormat('h:mm a').format(widget.session.dateTime!)}",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
