class Constants {
  static const String appName = 'Flutter Demo';
  static const double sufficientWorkingHours = 8;
  static String getPunishmentHours(double punishmentHours) {
    if (punishmentHours == 0) {
      return '0';
    } else if (punishmentHours < 2) {
      return '100.000';
    } else if (punishmentHours < 5) {
      return '500.000';
    } else {
      return '1.000.000';
    }
  }

  static String getSalary(int salary) {
    final String salaryString = salary.toString();
    String result = '';
    int count = 0;
    for (int i = salaryString.length - 1; i >= 0; i--) {
      count++;
      result = salaryString[i] + result;
      if (count == 3 && i != 0) {
        result = '.$result';
        count = 0;
      }
    }
    return result;
  }
}
