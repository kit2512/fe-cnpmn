class Constants {
  static const String appName = 'Flutter Demo';
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
}
