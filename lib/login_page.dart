import 'package:aplicacion_seminario/courses_page.dart';
import 'package:aplicacion_seminario/models/course_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

// const SERVER_URL = 'http://10.0.0.17:3000';
const SERVER_URL = 'https://servidorseminariogo.herokuapp.com/';
const SERVER_NAMESPACE = '/';
const SERVER_QUERY = '';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  SocketIO socketIO;

  @override
  void initState() {
    super.initState();
    _usernameController = new TextEditingController();
    _passwordController = new TextEditingController();
  }

  String _getJsonString(String data) {
    if (data[0] == '[') {
      return data.substring(1, data.length - 1);
    } else {
      return data;
    }
  }

  void _login() {
    print('Boton de login precionado');
    print('Username: ${_usernameController.text}');
    print('Password: ${_passwordController.text}');

    AlertDialog alert = new AlertDialog(
      title: new Center(child: new Text('VERIFICANDO CONTRASEÑA')),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            new Text('USUARIO: ${_usernameController.text}'),
            new Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Center(child: CircularProgressIndicator()))
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => alert);

    socketIO = SocketIOManager()
        .createSocketIO(SERVER_URL, SERVER_NAMESPACE, query: SERVER_QUERY);
    socketIO.init();
    socketIO.connect();

    socketIO.subscribe('server_connected', _onServerConnected);
    socketIO.subscribe('successful_login', _onSuccessfulLogin);
    socketIO.subscribe('incorrect_password', _onIncorrectPassword);
    socketIO.subscribe('user_not_exist', _onUserNotExist);
  }

  void _onServerConnected(dynamic data) {
    print('SERVIDOR CONECTADO');
    socketIO.sendMessage('login_request',
        '{"username": "${_usernameController.text}", "password": "${_passwordController.text}"}');
  }

  void _onSuccessfulLogin(dynamic data) {
    dynamic dataFix = _getJsonString(data);

    var dataJson = jsonDecode(dataFix);

    List<CourseModel> courseList = new List();
    int tam = dataJson['courses'].length;

    for (int i = 0; i < tam; ++i) {
      String name = dataJson['courses'][i];
      courseList.add(CourseModel(name: name));
    }

    Navigator.of(context).pop();
    socketIO.destroy();

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoursesPage(coursesList: courseList)));
  }

  void _onIncorrectPassword(dynamic data) {
    Navigator.of(context).pop();

    AlertDialog alert = new AlertDialog(
      title: new Center(child: new Text('CONTRASEÑA INCORRECTA')),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            new Text('USUARIO: ${_usernameController.text}')
          ],
        ),
      ),
      actions: <Widget>[
        new Center(
            child: new FlatButton(
          child: new Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ))
      ],
    );

    showDialog(context: context, builder: (_) => alert);

    socketIO.destroy();
  }

  void _onUserNotExist(dynamic data) {
    Navigator.of(context).pop();

    AlertDialog alert = new AlertDialog(
      title: new Center(child: new Text('USUARIO NO EXISTENTE')),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            new Text('USUARIO: ${_usernameController.text}')
          ],
        ),
      ),
      actions: <Widget>[
        new Center(
            child: new FlatButton(
          child: new Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ))
      ],
    );

    showDialog(context: context, builder: (_) => alert);

    socketIO.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage('assets/img/fondo-ucb.jpg'),
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image(
                image: new AssetImage('assets/img/logo-ucb.png'),
                height: 100,
                width: 100,
              ),
              new Form(
                child: Theme(
                  data: new ThemeData(
                      brightness: Brightness.dark,
                      primarySwatch: Colors.teal,
                      inputDecorationTheme: new InputDecorationTheme(
                          labelStyle: new TextStyle(
                              color: Colors.teal, fontSize: 20.0))),
                  child: new Container(
                    padding: const EdgeInsets.all(40.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new TextFormField(
                          controller: _usernameController,
                          decoration: new InputDecoration(hintText: 'Usuario'),
                          keyboardType: TextInputType.text,
                        ),
                        new TextFormField(
                          controller: _passwordController,
                          decoration:
                              new InputDecoration(hintText: 'Contraseña'),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                        ),
                        new MaterialButton(
                          height: 40.0,
                          minWidth: 100.0,
                          color: Colors.teal,
                          textColor: Colors.white,
                          child: new Text('Ingresar'),
                          onPressed: _login,
                          splashColor: Colors.blue,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
