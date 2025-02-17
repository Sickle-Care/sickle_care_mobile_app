import 'package:flutter/material.dart';
import 'package:sickle_cell_app/models/goal.dart';

class GoalItem extends StatelessWidget {
  const GoalItem(
      {super.key,
      required this.color,
      required this.goal,
      required this.onTapGoal});

  final Color color;
  final Goal goal;
  final void Function() onTapGoal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapGoal,
      child: Container(
        height: 90,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        margin: EdgeInsets.only(bottom: 16.0),
        child: ListTile(
          title: Text(
            goal.title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Click to see ${goal.title} goal progress",
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            "${goal.goalCompletedPercentage.toStringAsFixed(0)}%",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
