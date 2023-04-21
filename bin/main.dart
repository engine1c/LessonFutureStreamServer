import 'dart:async';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' as io;

void main(List<String> arguments) {
  //useFuture2();
  //readFile();
  //useStream3();
  startServer();
}

void startServer()async{
var server = await io.HttpServer.bind('localhost', 4444);
print('startServer....');
server.listen((io.HttpRequest request) {
  request.response.write('Привет HttpServer!!!');
  request.response.close();
 });
}
void useFuture2() async{

print('start2...');
    try{
      var result = await fetchUser(2);
        print(result);      
    }
    catch(e){
       print(e); 
    }

print('...end2');
}

void useFuture1(){
  print('start...');
  fetchUser(2).then((value) {
    value['proc'] = 'trueeee';
      return value;
  
}
)
.then((value) =>print(value))
.catchError((e){
  print(e);
}
);
print('...end...');
}

//Future
Future<Map<String,String>> fetchUser(int userID)async{

  final packageUrl = Uri.https('jsonplaceholder.typicode.com', '/users/$userID');
  final packageResponse = await http.get(packageUrl);

  var map = json.decode(packageResponse.body) as Map;
  return {'id':map['id'].toString(), 'name': map['name'], 'username': map['username'], 'email': map['email']};
  //return Future.delayed(Duration(seconds: userID),() => {'id':userID.toString(),'named':'Max'});
  //return Future.delayed(Duration(seconds: userID),() =>throw Exception('___Exception___'));
}

void useStream1() async {
  var stream = streamOfInts().where((randNum) => randNum < 100).take(3);
  await for(int randNum in stream){
    print(randNum);
  }
}

void useStream2(){
  streamOfInts().skip(2).listen((randNum) {print(randNum); });
}

void useStream3(){
  strCtrlExp().skip(1).listen((randNum) {print(randNum); });
}
//stream
Stream<int> streamOfInts() async*{
  for(var i = 0; i < 6; i++){
    var randNum = Random().nextInt(300);
    await Future.delayed(Duration(milliseconds: randNum));
    yield randNum;
  }
}

void readFile()async{
 var content = io.File('bin/file.txt').openRead(); 

 //1
// var stream = content.transform(utf8.decoder).transform(LineSplitter());
// await for(var line in stream){
//   print(line);
// }

//2
//var lines = await content.transform(utf8.decoder).transform(LineSplitter()).toList();

//3
var lines = await transFileCont(content.transform(utf8.decoder).transform(LineSplitter())).toList();

print(lines);
}

Stream<String> transFileCont(Stream<String> stream) async*{
  await for(var line in stream){
    yield ':::> $line';
  }
}
Stream<int> strCtrlExp(){
  var ctrl = StreamController<int>();
  ctrl.sink.add(Random().nextInt(1000));
  ctrl.add(Random().nextInt(2000));
  ctrl.add(Random().nextInt(3000));
  ctrl.add(Random().nextInt(4000));
  return ctrl.stream;
}
