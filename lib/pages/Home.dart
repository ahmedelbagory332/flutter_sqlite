import 'package:flutter/material.dart';
import 'package:flutter_sqlite/model/course.dart';
import 'package:flutter_sqlite/pages/newcourse.dart';
import 'package:flutter_sqlite/pages/updatecourse.dart';

import '../dbhelper.dart';
import 'coursedetails.dart';

class Home extends StatefulWidget {


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _HomeState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredCourse = allCourses;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }


  DbHelper helper;
  Icon _searchIcon =   Icon(Icons.search);
  Widget _appBarTitle = Text('SQLite Database');
  final TextEditingController _filter = new TextEditingController();
  List allCourses = new List();
  var filteredCourse = List();
  String _searchText = "";


  @override
  void initState() {
    super.initState();
    helper = DbHelper();
    getCourses();
  }

  void getCourses() {
    helper.allCourses().then((courses){
      setState(() {
        allCourses = courses;
        filteredCourse = allCourses;
      });
    });
  }


  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search...'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('SQLite Database');
       // filteredNames = names;
        _filter.clear();
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < filteredCourse.length; i++) {
        if (filteredCourse[i]['name'].toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(filteredCourse[i]);
        }
      }
      filteredCourse = tempList;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => NewCourse()));
              setState(() {
                getCourses();
              });
            },
          )
        ],
        leading: new IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,

        ),
      ),
      body: filteredCourse.length==0?Center(child: Text("no data")):ListView.builder(
          itemCount: allCourses == null ? 0 : filteredCourse.length,
          itemBuilder: (context, i){
            Course course = Course(filteredCourse[i]);
            return ListTile(
              title: Text('${course.name} - ${course.hours} hours'),
              subtitle: Text(course.content),
              trailing: Column(
                children: <Widget>[
                  Expanded(
                    child: IconButton(icon: Icon(Icons.delete, color: Colors.red,),onPressed: (){
                      setState(() {
                        helper.delete(course.id);
                        getCourses();
                      });
                    },),
                  ),
                  Expanded(
                    child: IconButton(icon: Icon(Icons.edit, color: Colors.green,),onPressed: () async{
                      await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpdateCourse(course)));
                      setState(() {
                        getCourses();
                      });
                    },),
                  ),
                ],
              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CourseDetails(course)));
              },
            );
          }
      ),
    );
  }
}