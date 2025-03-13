import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sickle_cell_app/providers/admin_provider.dart';
import 'package:sickle_cell_app/resources/async_handler.dart';
import 'package:sickle_cell_app/models/user.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';
import 'package:sickle_cell_app/screens/admin_screens/add_user_screen.dart';

class AdminListScreen extends ConsumerStatefulWidget {
  const AdminListScreen({super.key});

  @override
  ConsumerState<AdminListScreen> createState() => _AdminListScreenState();
}

class _AdminListScreenState extends ConsumerState<AdminListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      _getAdmins();
    });
  }

  void _getAdmins() async {
    try {
      ref.read(adminProvider.notifier).fetchAdmins();
    } catch (e) {
      showErrorSnackbar("An error occurred: $e", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final admins = ref.watch(adminProvider);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("ADMINS LIST"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final response = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddUserScreen(
                    userRole: "Admin",
                  ),
                ),
              );

              if (response == true) {
                _getAdmins();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          padding: EdgeInsets.all(15),
          child: AsyncHandler<List<User>>(
            asyncValue: admins,
            onData: (context, admins) {
              if (admins.isEmpty) {
                return Center(
                  child: Text(
                    "No admins available",
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
                  ...admins.map(
                    (admin) => Column(
                      children: [
                        SingleDoctorRow(
                          name: "${admin.firstName} ${admin.lastName}",
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
  });

  final String name;

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
          ],
        ),
      ),
    );
  }
}
