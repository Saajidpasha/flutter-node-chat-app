import 'package:flutter/material.dart';
import './chatPage.dart';

void main()=>runApp(Home());

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
      theme: ThemeData(
        primaryColor: Colors.teal
      ),
    );

  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Whatsapp'),
        actions: [
          IconButton(icon: Icon(Icons.chat),onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return ChatPage();
            }));
          },)
        ],

      ),
      body: SafeArea(
        child: Center(child: Text('Main Page')),
      ),
      
    );
  }
}

