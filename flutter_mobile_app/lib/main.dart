import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:twitter_clone/mainPage.dart';
import 'package:twitter_clone/registerPage.dart';
import 'globals.dart' as globals;






void main()
{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(LoginScreen()));
}


class LoginScreen extends StatelessWidget
{
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget
{

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  void _showAlert(BuildContext context ,String message)
  {
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: <Widget>
          [
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool isEmail(String text)
  {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(text);
  }



  Future<void> getAllPosts() async
  {
    var url = Uri.parse('http://192.168.1.34:8000/getAllPosts');

    try
    {
      var response = await
      http.get(
        url,
      );



      if (response.statusCode == 200)
      {
        var data = response.body;
        globals.getAllPostsJSON=data;


        Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
        Navigator.of(context, rootNavigator: true).pushNamed("/main");
      }

      else if (response.statusCode ==204)
      {
        _showAlert(context,"user doesnt exist");
      }

      else
      {
        _showAlert(context,response.statusCode.toString());
        print('Request failed with status: ${response.statusCode}');
      }
    }

    catch (e)
    {
      _showAlert(context,e.toString());
      print('Error: $e');
    }

  }




  Future<void> login(email,password) async
  {
    var url = Uri.parse('http://192.168.1.34:8000/login');

    var headers =
    {
      'Content-Type': 'application/json',
    };

    var body =
    {
      'email': email,
      'password': password,
    };


    try
    {
      var response = await
      http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (email=="" || password=="" )
      {
        _showAlert(context,"email and password is required");
      }

      else if (!isEmail(email))
      {
        _showAlert(context,"enter valid email");
      }

      else if (response.statusCode == 200)
      {
        var data = response.body;
        var jsonData = json.decode(data);
        var id=jsonData["id"];
        var username=jsonData["username"];
        globals.id=id;
        globals.username=username;
        // print("username");
        // print(username);
        //
        // print("id:");
        // print(jsonData["id"]);
        getAllPosts();
        Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
        Navigator.of(context, rootNavigator: true).pushNamed("/main");
      }

      else if (response.statusCode ==204)
      {
        _showAlert(context,"user doesnt exist");
      }

      else
      {
        _showAlert(context,response.statusCode.toString());
        print('Request failed with status: ${response.statusCode}');
      }
    }

    catch (e)
    {
      _showAlert(context,e.toString());
      print('Error: $e');
    }

  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar
          (
            title: const Text("Twitter Clone"),
          automaticallyImplyLeading: false,
          ),
        body:Column(
            children:  <Widget>
            [
              const Text(""),
              const Text(""),
              TextField(
                controller:emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
              const Text(""),

              TextField(
                controller:passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
              const Text(""),

              ElevatedButton(
                onPressed: ()
                {
                  login(emailController.text,passwordController.text);
                },
                child: const Text('Login',style: TextStyle(fontSize: 25)),
              ),

              const Text(""),
              const Text(""),
              const Text("Don't you have a account?"),

              ElevatedButton(
                onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                  },
                child: const Text('Create account',style: TextStyle(fontSize: 25)),
              ),
            ]
        )
    );
  }
}
