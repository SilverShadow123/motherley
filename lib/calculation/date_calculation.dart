class DateCalculator {
  final DateTime? dueDate;

  DateCalculator([this.dueDate]);

  DateTime getLmpDate() {
    return dueDate != null
        ? dueDate!.subtract(const Duration(days: 280))
        : DateTime.now();
  }

  int calculateDaysPassed(DateTime currentDate, DateTime lmpDate) {
    return currentDate.difference(lmpDate).inDays;
  }

  int calculateWeeksPassed(int daysPassed) {
    return daysPassed ~/ 7;
  }

  int calculateMonthsPassed(DateTime currentDate, DateTime lmpDate) {
    return (currentDate.year - lmpDate.year) * 12 +
        (currentDate.month - lmpDate.month);
  }

  DateTime calculateDueDate(DateTime lmpDate) {
    return lmpDate.add(const Duration(days: 280));
  }

  bool isValidDate(int day, int month, int year) {
    if (month < 1 || month > 12 || day < 1 || day > 31) return false;

    if (month == 2) {
      if (day > (isLeapYear(year) ? 29 : 28)) return false;
    }
    if ([4, 6, 9, 11].contains(month) && day > 30) return false;
    return true;
  }

  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}
