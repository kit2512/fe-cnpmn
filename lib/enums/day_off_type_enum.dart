enum DayOffType {
  paid,
  unpaid;

  String get title => this == DayOffType.paid ? 'Nghỉ có phép' : 'Nghỉ không phép';
}
