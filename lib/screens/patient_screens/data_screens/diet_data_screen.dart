import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:sickle_cell_app/constants/dropdown_values.dart';
import 'package:sickle_cell_app/models/health_record.dart';
import 'package:sickle_cell_app/providers/healthRecord_provider.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';
import 'package:sickle_cell_app/services/healthrecord_service.dart';
import 'package:sickle_cell_app/widgets/button.dart';

class DietDataScreen extends ConsumerStatefulWidget {
  const DietDataScreen({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  ConsumerState<DietDataScreen> createState() => _DietDataScreenState();
}

class _DietDataScreenState extends ConsumerState<DietDataScreen> {
  String ironBValue = iron.first;
  String folateBValue = folate.first;
  String vitaminBBValue = vitaminB.first;
  String vitaminCBValue = vitaminC.first;
  String zincBValue = zinc.first;
  String magnesiumBValue = magnesium.first;
  String omega3BValue = omega3.first;
  String proteinBValue = protein.first;
  String calciumBValue = calcium.first;
  String ironLValue = iron.first;
  String folateLValue = folate.first;
  String vitaminBLValue = vitaminB.first;
  String vitaminCLValue = vitaminC.first;
  String zincLValue = zinc.first;
  String magnesiumLValue = magnesium.first;
  String omega3LValue = omega3.first;
  String proteinLValue = protein.first;
  String calciumLValue = calcium.first;
  String ironDValue = iron.first;
  String folateDValue = folate.first;
  String vitaminBDValue = vitaminB.first;
  String vitaminCDValue = vitaminC.first;
  String zincDValue = zinc.first;
  String magnesiumDValue = magnesium.first;
  String omega3DValue = omega3.first;
  String proteinDValue = protein.first;
  String calciumDValue = calcium.first;

  @override
  void initState() {
    super.initState();
    final healthRecord = ref.read(healthRecordProvider);
    if (healthRecord != null) {
      ironBValue = healthRecord.diet!.breakfast.iron!;
      folateBValue = healthRecord.diet!.breakfast.folateVitaminB9!;
      vitaminBBValue = healthRecord.diet!.breakfast.vitaminB12!;
      vitaminCBValue = healthRecord.diet!.breakfast.vitaminC!;
      zincBValue = healthRecord.diet!.breakfast.zinc!;
      magnesiumBValue = healthRecord.diet!.breakfast.magnesium!;
      omega3BValue = healthRecord.diet!.breakfast.omega3FattyAcids!;
      proteinBValue = healthRecord.diet!.breakfast.protein!;
      calciumBValue = healthRecord.diet!.breakfast.calciumVitaminD!;
      ironLValue = healthRecord.diet!.lunch.iron!;
      folateLValue = healthRecord.diet!.lunch.folateVitaminB9!;
      vitaminBLValue = healthRecord.diet!.lunch.vitaminB12!;
      vitaminCLValue = healthRecord.diet!.lunch.vitaminC!;
      zincLValue = healthRecord.diet!.lunch.zinc!;
      magnesiumLValue = healthRecord.diet!.lunch.magnesium!;
      omega3LValue = healthRecord.diet!.lunch.omega3FattyAcids!;
      proteinLValue = healthRecord.diet!.lunch.protein!;
      calciumLValue = healthRecord.diet!.lunch.calciumVitaminD!;
      ironDValue = healthRecord.diet!.dinner.iron!;
      folateDValue = healthRecord.diet!.dinner.folateVitaminB9!;
      vitaminBDValue = healthRecord.diet!.dinner.vitaminB12!;
      vitaminCDValue = healthRecord.diet!.dinner.vitaminC!;
      zincDValue = healthRecord.diet!.dinner.zinc!;
      magnesiumDValue = healthRecord.diet!.dinner.magnesium!;
      omega3DValue = healthRecord.diet!.dinner.omega3FattyAcids!;
      proteinDValue = healthRecord.diet!.dinner.protein!;
      calciumDValue = healthRecord.diet!.dinner.calciumVitaminD!;
    }
  }

  void updateDiet(HealthRecord healthRecord) async {
    try {
      Diet updatedDiet = healthRecord.diet!.copyWith(
        breakfast: Meal(
            iron: ironBValue,
            folateVitaminB9: folateBValue,
            vitaminB12: vitaminBBValue,
            vitaminC: vitaminCBValue,
            zinc: zincBValue,
            magnesium: magnesiumBValue,
            omega3FattyAcids: omega3BValue,
            protein: proteinBValue,
            calciumVitaminD: calciumBValue),
        lunch: Meal(
            iron: ironLValue,
            folateVitaminB9: folateLValue,
            vitaminB12: vitaminBLValue,
            vitaminC: vitaminCLValue,
            zinc: zincLValue,
            magnesium: magnesiumLValue,
            omega3FattyAcids: omega3LValue,
            protein: proteinLValue,
            calciumVitaminD: calciumLValue),
        dinner: Meal(
            iron: ironDValue,
            folateVitaminB9: folateDValue,
            vitaminB12: vitaminBDValue,
            vitaminC: vitaminCDValue,
            zinc: zincDValue,
            magnesium: magnesiumDValue,
            omega3FattyAcids: omega3DValue,
            protein: proteinDValue,
            calciumVitaminD: calciumDValue),
      );
      HealthrecordService healthRecordService = HealthrecordService();
      var response = await healthRecordService.updateDiet(
          updatedDiet, healthRecord.recordId);
      if (response.recordId != "") {
        ref.read(healthRecordProvider.notifier).setRecord(response);
        showSuccessSnackbar("Successfully updated diet details", context);
      } else {
        showErrorSnackbar("Failed to update diet details", context);
      }
    } catch (e) {
      showErrorSnackbar("Failed to update diet details", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final healthRecord = ref.watch(healthRecordProvider);
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("DIET GOAL DETAILS"),
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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.08, vertical: height * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Breakfast',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MealDropDown(
                        value: ironBValue,
                        items: iron,
                        hint: "Iron (Non-Heme)",
                        onChanged: (String? value) {
                          setState(() {
                            ironBValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: folateBValue,
                        items: folate,
                        hint: "Folate (Vitamin B9)",
                        onChanged: (String? value) {
                          setState(() {
                            folateBValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: vitaminBBValue,
                        items: vitaminB,
                        hint: "Vitamin B12",
                        onChanged: (String? value) {
                          setState(() {
                            vitaminBBValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: vitaminCBValue,
                        items: vitaminC,
                        hint: "Vitamin C",
                        onChanged: (String? value) {
                          setState(() {
                            vitaminCBValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: zincBValue,
                        items: zinc,
                        hint: "Zinc",
                        onChanged: (String? value) {
                          setState(() {
                            zincBValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: magnesiumBValue,
                        items: magnesium,
                        hint: "Magnesium",
                        onChanged: (String? value) {
                          setState(() {
                            magnesiumBValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: omega3BValue,
                        items: omega3,
                        hint: "Omega-3 Fatty Acids",
                        onChanged: (String? value) {
                          setState(() {
                            omega3BValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: proteinBValue,
                        items: protein,
                        hint: "Protein",
                        onChanged: (String? value) {
                          setState(() {
                            proteinBValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: calciumBValue,
                        items: calcium,
                        hint: "Calcium & Vitamin D",
                        onChanged: (String? value) {
                          setState(() {
                            calciumBValue = value!;
                          });
                        },
                      ),
                    ],
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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.08, vertical: height * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lunch',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MealDropDown(
                        value: ironLValue,
                        items: iron,
                        hint: "Iron (Non-Heme)",
                        onChanged: (String? value) {
                          setState(() {
                            ironLValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: folateLValue,
                        items: folate,
                        hint: "Folate (Vitamin B9)",
                        onChanged: (String? value) {
                          setState(() {
                            folateLValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: vitaminBLValue,
                        items: vitaminB,
                        hint: "Vitamin B12",
                        onChanged: (String? value) {
                          setState(() {
                            vitaminBLValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: vitaminCLValue,
                        items: vitaminC,
                        hint: "Vitamin C",
                        onChanged: (String? value) {
                          setState(() {
                            vitaminCLValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: zincLValue,
                        items: zinc,
                        hint: "Zinc",
                        onChanged: (String? value) {
                          setState(() {
                            zincLValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: magnesiumLValue,
                        items: magnesium,
                        hint: "Magnesium",
                        onChanged: (String? value) {
                          setState(() {
                            magnesiumLValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: omega3LValue,
                        items: omega3,
                        hint: "Omega-3 Fatty Acids",
                        onChanged: (String? value) {
                          setState(() {
                            omega3LValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: proteinLValue,
                        items: protein,
                        hint: "Protein",
                        onChanged: (String? value) {
                          setState(() {
                            proteinLValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: calciumLValue,
                        items: calcium,
                        hint: "Calcium & Vitamin D",
                        onChanged: (String? value) {
                          setState(() {
                            calciumLValue = value!;
                          });
                        },
                      ),
                    ],
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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.08, vertical: height * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dinner',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MealDropDown(
                        value: ironDValue,
                        items: iron,
                        hint: "Iron (Non-Heme)",
                        onChanged: (String? value) {
                          setState(() {
                            ironDValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: folateDValue,
                        items: folate,
                        hint: "Folate (Vitamin B9)",
                        onChanged: (String? value) {
                          setState(() {
                            folateDValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: vitaminBDValue,
                        items: vitaminB,
                        hint: "Vitamin B12",
                        onChanged: (String? value) {
                          setState(() {
                            vitaminBDValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: vitaminCDValue,
                        items: vitaminC,
                        hint: "Vitamin C",
                        onChanged: (String? value) {
                          setState(() {
                            vitaminCDValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: zincDValue,
                        items: zinc,
                        hint: "Zinc",
                        onChanged: (String? value) {
                          setState(() {
                            zincDValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: magnesiumDValue,
                        items: magnesium,
                        hint: "Magnesium",
                        onChanged: (String? value) {
                          setState(() {
                            magnesiumDValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: omega3DValue,
                        items: omega3,
                        hint: "Omega-3 Fatty Acids",
                        onChanged: (String? value) {
                          setState(() {
                            omega3DValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: proteinDValue,
                        items: protein,
                        hint: "Protein",
                        onChanged: (String? value) {
                          setState(() {
                            proteinDValue = value!;
                          });
                        },
                      ),
                      MealDropDown(
                        value: calciumDValue,
                        items: calcium,
                        hint: "Calcium & Vitamin D",
                        onChanged: (String? value) {
                          setState(() {
                            calciumDValue = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MyButton(
                  onPressed: () {
                    updateDiet(healthRecord!);
                  },
                  buttonText: "Update Meal Details"),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MealDropDown extends StatelessWidget {
  const MealDropDown({
    super.key,
    required this.value,
    required this.items,
    required this.hint,
    this.onChanged,
  });

  final String hint;
  final String value;
  final ValueChanged<String?>? onChanged;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text(hint),
      value: value.isEmpty ? null : value,
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
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
