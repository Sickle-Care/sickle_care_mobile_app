import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sickle_cell_app/models/medicine.dart';
import 'package:sickle_cell_app/models/user.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';
import 'package:sickle_cell_app/screens/add_medicine_screens/add_medicine_modal.dart';
import 'package:sickle_cell_app/screens/tabs_screen.dart';
import 'package:sickle_cell_app/services/medicine_service.dart';
import 'package:sickle_cell_app/widgets/button.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key, required this.user});

  final User user;

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  List<String> morningMedicines = [];
  List<String> dayMedicines = [];
  List<String> nightMedicines = [];

  void _showAddMedicineModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddMedicineModal(
        onAddMedicine: (time, medicine) {
          setState(() {
            if (time == 'Morning') {
              morningMedicines.add(medicine);
            } else if (time == 'Day') {
              dayMedicines.add(medicine);
            } else {
              nightMedicines.add(medicine);
            }
          });

          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              showSuccessSnackbar('$medicine added to $time', context);
            }
          });
        },
      ),
    );
  }

  void _removeMedicine(String medicine, String time) {
    setState(() {
      if (time == 'Morning') {
        morningMedicines = List.from(morningMedicines)..remove(medicine);
      } else if (time == 'Day') {
        dayMedicines = List.from(dayMedicines)..remove(medicine);
      } else {
        nightMedicines = List.from(nightMedicines)..remove(medicine);
      }
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      showErrorSnackbar('$medicine removed from $time', context);
    });
  }

  void submitMedicines() async {
    try {
      MedicineService medicineService = MedicineService();
      var response = await medicineService.createMedicineData(MedicineData(
        userId: widget.user.userId,
        patientId: widget.user.patientId!,
        medicines: MedicineSchedule(
          morning: morningMedicines,
          day: dayMedicines,
          night: nightMedicines,
        ),
      ));

      if (response != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TabsScreen(), // Pass user here
          ),
        );
      } else {
        showErrorSnackbar('Failed to add medicines', context);
      }
    } catch (e) {
      showErrorSnackbar('Failed to add medicines', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text("ADD MEDICINES"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          titleTextStyle: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(onPressed: _showAddMedicineModal, icon: Icon(Icons.add))
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Card(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Morning',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: width,
                          height: 20,
                        ),
                        if (morningMedicines.isEmpty)
                          Center(
                            child: Text(
                              'No medicines added',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: HexColor("#8d8d8d")),
                            ),
                          ),
                        for (var medicine in morningMedicines)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                medicine,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: HexColor("#8d8d8d")),
                              ),
                              IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _removeMedicine(medicine, 'Morning');
                                  }),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: width,
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.08, vertical: height * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Day',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: width,
                          height: 20,
                        ),
                        if (dayMedicines.isEmpty)
                          Center(
                            child: Text(
                              'No medicines added',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: HexColor("#8d8d8d")),
                            ),
                          ),
                        for (var medicine in dayMedicines)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                medicine,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: HexColor("#8d8d8d")),
                              ),
                              IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _removeMedicine(medicine, 'Day');
                                  }),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: width,
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.08, vertical: height * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Night',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: width,
                          height: 20,
                        ),
                        if (nightMedicines.isEmpty)
                          Center(
                            child: Text(
                              'No medicines added',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: HexColor("#8d8d8d")),
                            ),
                          ),
                        for (var medicine in nightMedicines)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                medicine,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: HexColor("#8d8d8d")),
                              ),
                              IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _removeMedicine(medicine, 'Night');
                                  }),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: width,
                  height: 20,
                ),
                MyButton(onPressed: () {}, buttonText: "Submit Medicines"),
                SizedBox(
                  width: width,
                  height: 10,
                ),
                // GestureDetector(
                //   onTap: () {},
                //   child: Container(
                //     padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
                //     height: 55,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       // color: Theme.of(context).colorScheme.primary,
                //       border: Border.all(color: HexColor("#8d8d8d"), width: 2),
                //       borderRadius: BorderRadius.circular(25),
                //     ),
                //     child: Text(
                //       "Set Up Later",
                //       textAlign: TextAlign.center,
                //       style: GoogleFonts.poppins(
                //         color: HexColor("#8d8d8d"),
                //         fontSize: 18,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //   ),
                //   // ),
                // ),
              ],
            ),
          ),
        ));
  }
}
