enum ExpenseFilterType {
  daily,
  weekly,
  monthly,
  yearly,
  all,
}

String filterLabel(ExpenseFilterType f) {
  switch (f) {
    case ExpenseFilterType.daily:
      return "Daily";
    case ExpenseFilterType.weekly:
      return "Weekly";
    case ExpenseFilterType.monthly:
      return "Monthly";
    case ExpenseFilterType.yearly:
      return "Yearly";
    default:
      return "All";
  }
}
