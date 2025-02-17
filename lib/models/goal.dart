class Goal {
  const Goal({
    required this.id,
    required this.title,
    required this.goal,
    required this.goalCompleted,
    required this.goalCompletedPercentage
  });

  final String id;
  final String title;
  final double goal;
  final double goalCompleted;
  final double goalCompletedPercentage;
}
