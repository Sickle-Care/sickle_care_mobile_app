import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sickle_cell_app/models/session.dart';
import 'package:sickle_cell_app/models/user.dart';
import 'package:sickle_cell_app/providers/user_provider.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';
import 'package:sickle_cell_app/widgets/button.dart';

class AddSessionModal extends ConsumerStatefulWidget {
  final List<User> patients;
  final Function(Session) onAddSession;

  const AddSessionModal({
    super.key,
    required this.patients,
    required this.onAddSession,
  });

  @override
  ConsumerState<AddSessionModal> createState() => _AddSessionModalState();
}

class _AddSessionModalState extends ConsumerState<AddSessionModal> {
  String? _selectedPatientId;
  String? _selectedPatientName;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now =
        DateTime.now().toUtc(); // Ensure the current time is in UTC

    if (Platform.isIOS) {
      // iOS: Show CupertinoDatePicker
      final DateTime initialDateTime = now.add(
          Duration(seconds: 1)); // Ensure initialDateTime is after minimumDate

      showCupertinoModalPopup(
        context: context,
        builder: (context) => Container(
          height: 350,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: Text("Done"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime:
                      initialDateTime, // Use adjusted initialDateTime
                  minimumDate: now, // Set minimumDate to now
                  maximumDate:
                      DateTime(2100).toUtc(), // Ensure maximumDate is in UTC
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDate = newDate; // Convert to UTC
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else if (Platform.isAndroid) {
      // Android: Show Material Date Picker
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: DateTime(2100).toUtc(), // Ensure lastDate is in UTC
      );
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked.toUtc(); // Convert to UTC
        });
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final DateTime now =
        DateTime.now().toUtc(); // Ensure the current time is in UTC

    if (Platform.isIOS) {
      // iOS: Show CupertinoDatePicker for Time
      showCupertinoModalPopup(
        context: context,
        builder: (context) => Container(
          height: 350,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: Text("Done"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: now, // Use UTC time
                  use24hFormat: false, // Use 12-hour format
                  onDateTimeChanged: (DateTime newTime) {
                    setState(() {
                      _selectedTime =
                          TimeOfDay.fromDateTime(newTime); // Convert to UTC
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else if (Platform.isAndroid) {
      // Android: Show Material Time Picker
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now), // Use UTC time
      );
      if (picked != null && picked != _selectedTime) {
        setState(() {
          _selectedTime = picked;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.8,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            keyBoardSpace + 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Text(
                  "Add Session",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: HexColor("#4f4f4f"),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: "Select Patient",
                    ),
                    value: _selectedPatientId,
                    icon: Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    elevation: 16,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: HexColor("#8d8d8d"),
                    ),
                    isExpanded: true,
                    iconSize: 25,
                    borderRadius: BorderRadius.circular(20),
                    items: widget.patients.map((patient) {
                      return DropdownMenuItem(
                        value: patient.patientId,
                        child: Text(patient.firstName + " " + patient.lastName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPatientId = value;
                        _selectedPatientName = widget.patients
                                .firstWhere(
                                    (patient) => patient.patientId == value)
                                .firstName +
                            " " +
                            widget.patients
                                .firstWhere(
                                    (patient) => patient.patientId == value)
                                .lastName;
                      });
                    },
                  ),
                ),
                SizedBox(height: 25),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      fillColor: HexColor("#f0f3f1"),
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      hintStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: 15,
                                color: HexColor("#8d8d8d"),
                              ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate != null
                              ? "${_selectedDate!}".split(' ')[0]
                              : "Select Date",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 15,
                                    color: HexColor("#8d8d8d"),
                                  ),
                        ),
                        Icon(Icons.calendar_today_outlined,
                            color: HexColor("#8d8d8d")),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () => _selectTime(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      fillColor: HexColor("#f0f3f1"),
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      hintStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: 15,
                                color: HexColor("#8d8d8d"),
                              ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedTime != null
                              ? _selectedTime!.format(context)
                              : "Select Time",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 15,
                                    color: HexColor("#8d8d8d"),
                                  ),
                        ),
                        Icon(Icons.access_time, color: HexColor("#8d8d8d")),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                MyButton(
                  onPressed: () {
                    if (_selectedPatientId != null &&
                        _selectedDate != null &&
                        _selectedTime != null) {
                      final DateTime sessionDateTime = DateTime.utc(
                        _selectedDate!.year,
                        _selectedDate!.month,
                        _selectedDate!.day,
                        _selectedTime!.hour,
                        _selectedTime!.minute,
                      );
                      final user = ref.read(userProvider);
                      final doctorId = user!.doctorId!;
                      final doctorName = user.firstName + " " + user.lastName;

                      final session = Session(
                        sessionId: "",
                        patientId: _selectedPatientId,
                        doctorId: doctorId,
                        doctorName: doctorName,
                        patientName: _selectedPatientName,
                        dateTime: sessionDateTime,
                        isAccepted: "PENDING",
                      );
                      widget.onAddSession(session);
                      Navigator.of(context).pop();
                    } else {
                      showErrorSnackbar("Please fill all fields", context);
                    }
                  },
                  buttonText: "Add Session",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
