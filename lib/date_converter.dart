import 'package:intl/intl.dart';

String dateNameMonth(DateTime dateTime) {
  DateFormat dateFormat = DateFormat('d MMMM');
  String formattedDate = dateFormat.format(dateTime);
  return formattedDate;
}
