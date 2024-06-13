// DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: _scheduleTime,
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime(2100),
//                   );
//                   if (picked != null) {
//                     TimeOfDay? time = await showTimePicker(
//                       context: context,
//                       initialTime: TimeOfDay.fromDateTime(_scheduleTime),
//                     );
//                     if (time != null) {
//                       setState(() {
//                         _scheduleTime = DateTime(
//                           picked.year,
//                           picked.month,
//                           picked.day,
//                           time.hour,
//                           time.minute,
//                         );
//                       });
//                     }
//                   }