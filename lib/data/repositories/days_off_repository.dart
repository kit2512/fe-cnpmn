import 'package:fe_cnpmn/data/datasources/days_off_datasource.dart';
import 'package:fe_cnpmn/data/models/day_off_model.dart';

class DaysOffRepository {
  final DaysOffDataSource _ds;

  DaysOffRepository(this._ds);

  Future<DayOffModel> createDayOff(DayOffModel newDayOff) async {
    return _ds.createDayOff(newDayOff);
  }

  Future<DayOffModel> updateDayOff(DayOffModel dayOff) => _ds.updateDayOff(dayOff);
}