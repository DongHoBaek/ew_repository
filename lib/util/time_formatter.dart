import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String timeFormatter(Timestamp timestamp){
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formattedPostTime =
  formatter.format(timestamp.toDate());

  return formattedPostTime;
}