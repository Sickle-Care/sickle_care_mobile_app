import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sickle_cell_app/models/session_chat.dart';
import 'package:sickle_cell_app/providers/session_chat_provider.dart';
import 'package:sickle_cell_app/providers/user_provider.dart';
import 'package:sickle_cell_app/resources/async_handler.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';
import 'package:sickle_cell_app/screens/patient_screens/session_chat_screens/session_chat_screen_patient.dart';

class SessionChatListScreenPatient extends ConsumerStatefulWidget {
  const SessionChatListScreenPatient({super.key});

  @override
  ConsumerState<SessionChatListScreenPatient> createState() =>
      _SessionChatListScreenPatientState();
}

class _SessionChatListScreenPatientState
    extends ConsumerState<SessionChatListScreenPatient> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Delay provider modification using Future.microtask
    Future.microtask(() {
      _getChats();
    });
  }

  void _getChats() async {
    final user = ref.watch(userProvider);
    try {
      ref
          .read(sessionChatProvider.notifier)
          .fetchSessionChatsByPatientId(user!.patientId!);
    } catch (e) {
      showErrorSnackbar("Failed to get chats", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chats = ref.watch(sessionChatProvider);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("SESSION CHAT LIST"),
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
          child: AsyncHandler<List<SessionChat>>(
            asyncValue: chats,
            onData: (context, chats) {
              if (chats.isEmpty) {
                return Center(
                  child: Text(
                    "No chats available",
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
                  ...chats.map(
                    (chat) => Column(
                      children: [
                        SingleChatRow(
                          name: "${chat.doctorName}",
                          onChanged: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SessionChatScreenPatient(
                                  chat: chat,
                                ),
                              ),
                            );
                          },
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

class SingleChatRow extends StatefulWidget {
  const SingleChatRow({
    super.key,
    required this.name,
    required this.onChanged,
  });

  final String name;
  final Function() onChanged;

  @override
  State createState() => _SingleChatRowState();
}

class _SingleChatRowState extends State<SingleChatRow> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: widget.onChanged,
      child: Card(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Dr. ${widget.name}",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
