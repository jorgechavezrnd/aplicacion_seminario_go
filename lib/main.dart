import 'package:flutter/material.dart';
import 'package:aplicacion_seminario/login_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Control de asistencia',
      theme: ThemeData.dark(),
      home: LoginPage()
    );
  }
}