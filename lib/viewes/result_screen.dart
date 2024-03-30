import 'dart:typed_data';

import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final Uint8List result;
  final int zeroCount, infected;
  const ResultScreen({super.key, required this.result, required this.zeroCount, required this.infected});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Image.memory(widget.result,fit: BoxFit.fill,),
          ),
          const SizedBox(height: 10,),
          Text("Normal"),
          Text("${widget.zeroCount}",style: TextStyle(fontWeight: FontWeight.bold),),
          Text("Infected"),
          Text("${widget.infected}",style: TextStyle(fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
