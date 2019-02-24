import 'package:aplicacion_seminario/models/course_model.dart';
import 'package:flutter/material.dart';

class CoursesPage extends StatelessWidget {
  final List<CourseModel> coursesList;

  CoursesPage({this.coursesList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('CURSOS'),
        ),
        elevation: 0.7,
      ),
      body: ListView.builder(
          itemCount: this.coursesList.length,
          itemBuilder: (context, i) => Column(children: <Widget>[
                Divider(height: 10.0),
                ListTile(
                    title: Text(this.coursesList[i].name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () { print('CURSO ${this.coursesList[i].name} PRECIONADO!'); },    
                )
              ])),
    );
  }
}
