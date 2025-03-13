import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sickle_cell_app/models/session.dart';
import 'package:sickle_cell_app/models/session_chat.dart';
import 'package:sickle_cell_app/providers/session_provider.dart';
import 'package:sickle_cell_app/providers/user_provider.dart';
import 'package:sickle_cell_app/resources/async_handler.dart';
import 'package:sickle_cell_app/resources/snackbar.dart';

class SessionChatScreenPatient extends ConsumerStatefulWidget {
  const SessionChatScreenPatient({super.key, required this.chat});

  final SessionChat chat;

  @override
  ConsumerState<SessionChatScreenPatient> createState() =>
      _SessionChatScreenPatientState();
}

class _SessionChatScreenPatientState
    extends ConsumerState<SessionChatScreenPatient> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Scroll to the bottom after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    // Dispose the ScrollController to avoid memory leaks
    _scrollController.dispose();
    super.dispose();
  }

  // Method to scroll to the bottom
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent, // Scroll to the bottom
        duration: Duration(milliseconds: 300), // Animation duration
        curve: Curves.easeOut, // Animation curve
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Delay provider modification using Future.microtask
    Future.microtask(() {
      _getSessions();
    });
  }

  void _getSessions() async {
    final user = ref.watch(userProvider);
    try {
      ref.read(sessionProvider.notifier).fetchSessionsByChatIdAndPatientId(
          widget.chat.chatId!, user!.patientId!);
    } catch (e) {
      showErrorSnackbar("Failed to get messages", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(sessionProvider);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.chat.patientName}"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          width: width,
          padding: EdgeInsets.all(15),
          child: AsyncHandler<List<Session>>(
            asyncValue: sessions,
            onData: (context, sessions) {
              if (sessions.isEmpty) {
                return Center(
                  child: Text(
                    "No messages available",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: width * 0.8, // Limit the width
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Dr. ${session.doctorName} have scheduled a support session on ${DateFormat('yyyy-MM-dd').format(session.dateTime!)} at ${DateFormat('h:mm a').format(session.dateTime!)}!",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: Colors.black,
                                            ),
                                        maxLines:
                                            5, // Limit the number of lines
                                        overflow: TextOverflow
                                            .ellipsis, // Handle overflow
                                      ),
                                      SizedBox(height: 10),
                                      if (session.isAccepted == "PENDING")
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.green,
                                              ),
                                              onPressed: () async {
                                                try {
                                                  await ref
                                                      .read(sessionProvider
                                                          .notifier)
                                                      .acceptSession(
                                                          session.sessionId!);
                                                  _getSessions();
                                                  _scrollToBottom();
                                                } catch (e) {
                                                  showErrorSnackbar(
                                                      "Failed to accept session",
                                                      context);
                                                }
                                              },
                                              child: Text(
                                                "Accept",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                              onPressed: () async {
                                                try {
                                                  await ref
                                                      .read(sessionProvider
                                                          .notifier)
                                                      .declineSession(
                                                          session.sessionId!);
                                                  _getSessions();
                                                  _scrollToBottom();
                                                } catch (e) {
                                                  showErrorSnackbar(
                                                      "Failed to decline session",
                                                      context);
                                                }
                                              },
                                              child: Text(
                                                "Decline",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (session.isAccepted != "PENDING")
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Flexible(
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: width *
                                                      0.8, // Limit the width
                                                ),
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: session.isAccepted ==
                                                            'ACCEPT'
                                                        ? Colors.green
                                                        : Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    session.isAccepted ==
                                                            'ACCEPT'
                                                        ? "Accepted"
                                                        : "Declined",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                          color: Colors
                                                              .white, // Change text color
                                                        ),
                                                    maxLines:
                                                        3, // Limit the number of lines
                                                    overflow: TextOverflow
                                                        .ellipsis, // Handle overflow
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        if (session.isAccepted != "PENDING")
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: width * 0.8, // Limit the width
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      session.isAccepted == 'ACCEPT'
                                          ? "You have accepted the session"
                                          : "You have has declined the session",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: Colors
                                                .white, // Change text color
                                          ),
                                      maxLines: 3, // Limit the number of lines
                                      overflow: TextOverflow
                                          .ellipsis, // Handle overflow
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 10),
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
