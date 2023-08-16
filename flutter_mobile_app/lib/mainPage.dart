import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:twitter_clone/addPostPage.dart';
import 'package:twitter_clone/main.dart';

import 'globals.dart' as globals;




class MainPage extends StatelessWidget
{
  const MainPage({super.key});


  @override
  Widget build(BuildContext context)
  {
    var dataLength=0;
    for(var _ in jsonDecode(globals.getAllPostsJSON))
      {
        dataLength++;
      }

    return Scaffold(
        appBar: AppBar(
          title:  const Text('Main Page'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostPage()));
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            )
          ],
        ),
        body:

          ListView.builder(
            itemCount: dataLength,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(jsonDecode(globals.getAllPostsJSON)[index]["username"].toString(),style:  const TextStyle(fontSize: 25),),
                subtitle:
                  Column(children:  <Widget>
                      [
                        Text(jsonDecode(globals.getAllPostsJSON)[index]["postBody"].toString(),style:  const TextStyle(fontSize: 22),),
                    Row(children:  <Widget>
                        [
                       const   Text("Added: ",style:  TextStyle(fontSize: 15),),
                          Text(jsonDecode(globals.getAllPostsJSON)[index]["date"].toString(),style:  const TextStyle(fontSize: 15),),
                          const Text(" "),
                          Text(jsonDecode(globals.getAllPostsJSON)[index]["time"].toString(),style:  const TextStyle(fontSize: 15),),
                    ]),
                    Container(
                      width: double.infinity, // Set the width of the line to fill the screen horizontally
                      height: 3.0,            // Set the height of the line (thickness)
                      color: Colors.black,    // You can change the color of the line as needed
                    ),
                  ])
              );
            },
          ),
    );
  }
}