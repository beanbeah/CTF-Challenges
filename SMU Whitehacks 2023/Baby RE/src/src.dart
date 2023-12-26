import 'dart:io';
import 'dart:convert';

final List<int> flag = [
  31,
  123,
  0,
  1,
  5,
  77,
  31,
  81,
  94,
  18,
  44,
  38,
  77,
  97,
  96,
  77,
  60,
  122,
  81,
  87,
  84,
  86,
  75,
  73,
  116,
  39,
  21,
  17,
  39,
  115,
  112,
  35,
  34,
  46,
  56,
  8,
  12,
  51,
  46,
  58,
  3,
  16,
  35,
  54,
  1,
  31,
  115,
  109,
  113,
  127,
  24
];
void main() {
  print("Please enter the flag: ");
  List<int> input = stdin.readLineSync(encoding: latin1)!.codeUnits;
  if (input.length != flag.length) {
    print("Wrong length!");
    return;
  }
  List<int> output = [];
  for (int i = 0; i < input.length; i++) {
    output.add(input[i] ^ input[(i + 1) % input.length]);
  }
  for (int i = 0; i < output.length; i++) {
    output[i] = output[i] ^ i;
  }
  for (int i = 0; i < flag.length; i++) {
    if (output[i] != flag[i]) {
      print("Wrong flag!");
      return;
    }
  }
  print("Correct flag!");
}
