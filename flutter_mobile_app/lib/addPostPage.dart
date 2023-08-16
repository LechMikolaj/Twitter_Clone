import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:twitter_clone/mainPage.dart';
import 'globals.dart' as globals;



class AddPostPage extends StatelessWidget
{




  @override
  Widget build(BuildContext context)
  {
    return  MaterialApp(
      title: 'Kindacode.com',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget
{
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{

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


  Future<void> postData(userId,username,postBody) async
  {
    var url = Uri.parse('http://192.168.1.34:8000/addPost');

    var headers =
    {
      'Content-Type': 'application/json',
    };

    var body =
    {
      "userId":userId,
      "username":username,
      "postBody":postBody
    };


    try
    {
      var response = await
      http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode ==201)
      {
        _showAlert(context, "Post added successfully");
      }

      else {
        print('Request failed with status: ${response.statusCode}');
      }

    }

    catch (e)
    {
      _showAlert(context,e.toString());
      print('Error: $e');
    }

  }


  String? _enteredText = ' ';
  var isEnabled=true;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add post'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
            },
          )
        ],
      ),

      body:
      Column(
        children: <Widget>[
          Padding(
            padding:  EdgeInsets.all(20),
            child: TextField(
              inputFormatters:
              [
                LengthLimitingTextInputFormatter(320),
              ],
              onChanged: (value)
              {
                setState(()
                {
                  _enteredText = value;
                });
              },
              decoration:
              InputDecoration(
                  labelText: "Enter text:",
                  border: const OutlineInputBorder(),
                  counterText: '${_enteredText?.length.toString()} / 320',
                  counterStyle: const TextStyle(fontSize: 22, color: Colors.blue)
              ),
              maxLines: 8,
              minLines: 1,
            ),
          ),
          ElevatedButton(
            onPressed: ()
            {
              postData(globals.id,globals.username,_enteredText);
            },
            child: const Text('Add post',style: TextStyle(fontSize: 25)),
          ),



        ],
      )
    );
  }
}
