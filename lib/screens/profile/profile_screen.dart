import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sickle_cell_app/models/user.dart';
import 'package:sickle_cell_app/screens/auth/login_screen.dart';
import 'package:sickle_cell_app/screens/profile/edit_profile_screen.dart';
import 'package:sickle_cell_app/widgets/button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {super.key, required this.userDetails});

  final User userDetails;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void navigateToUpdatePage(BuildContext context) async {
    final updatedUser = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProfile(
          userDetails: widget.userDetails,
        ),
      ),
    );

  }

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Remove stored data

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("ProfileScreen User: ${widget.userDetails}");
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.06, vertical: height * 0.02),
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image(
                        image: AssetImage(
                            'assets/images/propic_placeholder.jpg.avif')),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${widget.userDetails.firstName} ${widget.userDetails.lastName}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.userDetails.email,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 200,
                  child: MyButton(
                    onPressed: () {
                      navigateToUpdatePage(context);
                    },
                    buttonText: 'Edit Profile',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider(
                  thickness: 0,
                ),
                const SizedBox(
                  height: 10,
                ),
                ProfileItem(
                  title: 'Sickle Cell Type',
                  data: widget.userDetails.sickleCellType,
                  icon: Icons.medical_information,
                ),
                ProfileItem(
                  title: 'Age',
                  data: widget.userDetails.age.toString(),
                  icon: Icons.calendar_month,
                ),
                ProfileItem(
                  title: 'Gender',
                  data: widget.userDetails.gender,
                  icon: widget.userDetails.gender == 'Male'
                      ? Icons.male_outlined
                      : Icons.female_outlined,
                ),
                ProfileItem(
                  title: 'Contact number',
                  data: widget.userDetails.contactNumber,
                  icon: Icons.phone,
                ),
                ProfileItem(
                  title: 'Emergency Contact number',
                  data: widget.userDetails.secConNumber,
                  icon: Icons.emergency_outlined,
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    logout(context);
                  },
                  // child: Padding(
                  // padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.red, width: 2)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout_outlined,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Log out',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  // ),
                ),
                SizedBox(
                  height: height * 0.1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.title,
    this.data,
    required this.icon,
  });

  final String title;
  final String? data;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        data!,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: HexColor("#8d8d8d"), fontWeight: FontWeight.bold),
      ),
    );
  }
}
