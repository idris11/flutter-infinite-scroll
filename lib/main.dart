import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterappinfinitescroll/model/news_model.dart';
import 'package:flutterappinfinitescroll/repository/news_repository.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 1;
  List<Articles> articles;
  ScrollController scrollController = ScrollController();
  int totalPages = 0;

  bool onNotification(ScrollNotification scrollNotification) {
    if (scrollNotification is ScrollUpdateNotification) {
      if (scrollController.position.maxScrollExtent > scrollController.offset &&
          scrollController.position.maxScrollExtent - scrollController.offset <=
              50) {
        setState(() {
          currentPage += 1;
          print('halaman sekarang: $currentPage');
          NewsRepository.getNewsData(currentPage).then((response) {
            print('halaman sekarang: $currentPage');
            if (response != null) {
              articles.addAll(response.articles);
              print('panjang: ${articles.length}');
            }
          });
        });
      }
    }
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NewsRepository.getNewsData(currentPage).then((response) {
      if (response != null) {
        setState(() {
          articles = response.articles;
          totalPages = response.totalResults;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: articles == null || articles.length == 0
          ? Center(child: CircularProgressIndicator())
          : NotificationListener(
              onNotification: onNotification,
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 20),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(articles[index].title),
                        ),
                        Divider()
                      ],
                    ),
                  );
                },
                itemCount: articles.length,
              ),
            ),
    );
  }
}
