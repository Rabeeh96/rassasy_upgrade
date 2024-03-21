import 'dart:math';

double roundDouble(double value, String places) {
  var pl = int.parse(places);
  num mod = pow(10.0, pl);
  return ((value * mod).round().toDouble() / mod);
}