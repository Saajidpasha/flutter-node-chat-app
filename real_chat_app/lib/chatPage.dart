
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'dart:convert';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  SocketIO socketIO;
  List<String> messages;
  double height,width;
  TextEditingController textEditingController;
  ScrollController scrollController;

  @override
  void initState() {
    
    messages = new List<String>();
    textEditingController = TextEditingController();
    scrollController = ScrollController();
    //creating the socket
    socketIO = SocketIOManager().createSocketIO(
    'https://flutter-node-chatapp.herokuapp.com/', '/');
    socketIO.init();

    //subscribe to an event to listen to
    socketIO.subscribe('receive_message', (jsonData){
      //convert json data to map
      Map<String,dynamic> data = json.decode(jsonData);
      this.setState(() {
        messages.add(data['message']);
      });
      scrollController.animateTo(scrollController.position.maxScrollExtent,
       duration: Duration(milliseconds: 600), curve: Curves.ease);

    });

    socketIO.connect();
    super.initState();
  }
  

  Widget buildSingleMessage(int index) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(bottom: 20.0, left: 20.0),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          messages[index],
          style: TextStyle(color: Colors.white, fontSize: 15.0),
        ),
      ),
    );
  }

  Widget buildMessageList() {
    return Container(
        height: height * 0.8,
        width: width,
        child: ListView.builder(
    controller: scrollController,
    itemCount: messages.length,
    itemBuilder: (BuildContext context, int index) {
      return buildSingleMessage(index);
    },
        ),
      );
  }

  Widget buildChatInput() {
    return Container(
      width: width * 0.7,
      padding: const EdgeInsets.all(2.0),
      margin: const EdgeInsets.only(left: 40.0),
      child: TextField(
        decoration: InputDecoration.collapsed(
          hintText: 'Send a message...',
        ),
        controller: textEditingController,
      ),
    );
  }

  Widget buildSendButton() {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurple,
      onPressed: () {
        //Check if the textfield has text or not
        if (textEditingController.text.isNotEmpty) {
          //Send the message as JSON data to send_message event
          socketIO.sendMessage(
              'send_message', json.encode({'message': textEditingController.text}));
          //Add the message to the list
          this.setState(() => messages.add(textEditingController.text));
          textEditingController.text = '';
          //Scrolldown the list to show the latest message
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 600),
            curve: Curves.ease,
          );
        }
      },
      child: Icon(
        Icons.send,
        size: 30,
      ),
    );
  }

  Widget buildInputArea() {
    return Container(
      height: height * 0.1,
      width: width,
      child: Row(
        children: <Widget>[
          buildChatInput(),
          buildSendButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
           // SizedBox(height: height * 0.1),
            buildMessageList(),
            buildInputArea(),
          ],
        ),
      ),
    );
  }
}