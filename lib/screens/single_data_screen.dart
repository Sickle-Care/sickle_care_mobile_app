import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SingleDataScreen extends StatefulWidget {
  const SingleDataScreen({super.key});

  @override
  State<SingleDataScreen> createState() => _SingleDataScreenState();
}

class _SingleDataScreenState extends State<SingleDataScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("WATER GOAL DETAILS"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Center(
              child: CircularPercentIndicator(
                radius: 100,
                lineWidth: 13,
                animation: true,
                percent: 0.5,
                center: Text(
                  "50%",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: const Color.fromARGB(255, 135, 206, 235),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "Date: 13-02-2025",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "Goal",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "2l",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                SizedBox(
                  width: width * 0.2,
                ),
                Column(
                  children: [
                    Text(
                      "Achived Goal",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "1l",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
              onPressed: () {},
              label: Text("Update"),
              icon: Icon(Icons.edit),
            )
          ],
        ),
      ),
    );
  }
}
