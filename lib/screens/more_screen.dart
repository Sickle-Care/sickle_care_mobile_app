import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sickle_cell_app/providers/doctor_provider.dart';
import 'package:sickle_cell_app/providers/user_provider.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';
import 'package:sickle_cell_app/screens/patient_screens/blog_list_screen.dart';
import 'package:sickle_cell_app/screens/patient_screens/daily_report_screen.dart';
import 'package:sickle_cell_app/screens/patient_screens/doctor_list_screen.dart';
import 'package:sickle_cell_app/screens/patient_screens/session_chat_screens/session_chat_list_screen_patient.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {
  String? userType;

  @override
  void initState() {
    super.initState();
    _fetchUserType();
  }

  void _fetchUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userType = prefs.getString('userType');
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userType == 'Patient') {
        _getDoctors();
      }
    });
  }

  void _getDoctors() async {
    final user = ref.read(userProvider);
    try {
      ref
          .read(doctorProvider.notifier)
          .fetchAvailableDoctorSByPatientId(user!.patientId!);
    } catch (e) {
      showErrorSnackbar("An error occurred: $e", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'More',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (userType == 'Patient') ...[
                ItemCard(
                    title: 'Daily Report',
                    icon: Icons.menu_book,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DailyReportScreen(),
                        ),
                      );
                    }),
                ItemCard(
                  title: "Doctor's Guide",
                  icon: Icons.medication,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DoctorListScreen(),
                      ),
                    );
                  },
                ),
              ],
              ItemCard(
                title: "Session Chat",
                icon: Icons.message,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SessionChatListScreenPatient(),
                    ),
                  );
                },
              ),
              ItemCard(
                title: "Blog Corner",
                icon: Icons.my_library_books,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlogListScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 90,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        margin: EdgeInsets.only(bottom: 16.0),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white.withValues(alpha: 0.3),
            ),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
