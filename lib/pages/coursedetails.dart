import 'package:flutter/material.dart';
import 'package:flutter_sqlite/model/course.dart';

class CourseDetails extends StatelessWidget {

  Course course;
  CourseDetails(this.course);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Course Details'),),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Text(course.name),
            SizedBox(height: 20,),
            Text(course.content),
            SizedBox(height: 20,),
            Text('${course.hours}', style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
          ],
        ),
      ),


    );
  }
}