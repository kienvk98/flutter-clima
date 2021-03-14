
import 'dart:io';

void main() async{
  task1();
  String s =await task2();
  task3(s);
}

void task1(){
  print('task 1 complete');
}

Future<String> task2() {
  Duration duration = Duration(seconds: 3);
  return Future.delayed(duration, (){
    print('task 2 complete');
    return 'next task';
  });
}

void task3(String s){
  print('$s');
  print('task 3 complete');
}