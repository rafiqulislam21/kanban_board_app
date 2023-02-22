import 'package:jiffy/jiffy.dart';

class Helper {
  static timeDifference({required String? start, required String? end}) {

    var time = "";
    if ((start?.length??0) < 1 || (end?.length??0) < 1) {
      return time;
    } else {
      var diff = Jiffy(end).diff(Jiffy(start), Units.MINUTE);
      if (diff <= 60) {
        time = "$diff minutes";
      } else {
        var diff = Jiffy(end).diff(Jiffy(start), Units.HOUR);
        if (diff <= 24) {
          time = "$diff hours";
        } else {
          var diff = Jiffy(end).diff(Jiffy(start), Units.DAY);
          if (diff <= 31) {
            time = "$diff days";
          } else {
            var diff = Jiffy(end).diff(Jiffy(start), Units.MONTH);
            time = "$diff months";
          }
        }
      }
    }
    return time;
  }
}
