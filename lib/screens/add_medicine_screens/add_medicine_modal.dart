import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sickle_cell_app/widgets/button.dart';

class AddMedicineModal extends StatefulWidget {
  const AddMedicineModal({super.key, required this.onAddMedicine});

  final Function(String, String) onAddMedicine;

  @override
  State createState() => _AddMedicineModalState();
}

class _AddMedicineModalState extends State<AddMedicineModal> {
  final TextEditingController _medicineController = TextEditingController();
  String _selectedTime = 'Morning';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.8,
      minChildSize: 0.8,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Text(
                "Add Medicine",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: HexColor("#4f4f4f"),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: width * 0.8,
                child: DropdownButton<String>(
                  value: _selectedTime,
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
                  onChanged: (newValue) {
                    setState(() {
                      _selectedTime = newValue!;
                    });
                  },
                  items: ['Morning', 'Day', 'Night']
                      .map((time) =>
                          DropdownMenuItem(value: time, child: Text(time)))
                      .toList(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _medicineController,
                keyboardType: TextInputType.number,
                cursorColor: HexColor("#4f4f4f"),
                decoration: InputDecoration(
                  hintText: "Medicine Name",
                  fillColor: HexColor("#f0f3f1"),
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  hintStyle: GoogleFonts.poppins(
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
              SizedBox(height: 16),
              MyButton(
                onPressed: () {
                  if (_medicineController.text.isNotEmpty) {
                    widget.onAddMedicine(
                        _selectedTime, _medicineController.text);
                    Navigator.pop(context);
                  }
                },
                buttonText: "Add",
              ),
            ],
          ),
        );
      },
    );
  }
}
