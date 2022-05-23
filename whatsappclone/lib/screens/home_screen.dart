import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Container(
            padding: EdgeInsets.all(20),
            color: Color.fromRGBO(0, 168, 132, 1),
            child: SafeArea(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("WhatsApp"),
                    Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.more_vert),
                      ],
                    ),
                  ],
                ),
                
              ]),
            ),
          )
          // AppBar(
          //   backgroundColor: Color.fromRGBO(0, 168, 132, 1),
          //   title: Text("WhatsApp"),
          //   actions: [
          //     Icon(Icons.search),
          //     SizedBox(
          //       width: 10,
          //     ),
          //     Icon(Icons.more_vert),
          //     SizedBox(
          //       width: 10,
          //     ),
          //   ],
          //   elevation: 0,
          // ),
          ),
    );
  }
}
