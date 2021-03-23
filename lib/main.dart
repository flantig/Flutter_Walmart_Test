import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:walmart_github_sampler/json/github_api_json_main.dart';

List<GithubAPIMain> _issues;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, accentColor: Colors.orange),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class TableSource extends DataTableSource {
  List<GithubAPIMain> _issues;

  TableSource(this._issues);

  @override
  DataRow getRow(int index) {
    final _singleIssue = _issues[index];
    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text('${_singleIssue.title}')),
      DataCell(Text('${_singleIssue.id}')),
      DataCell(Text('${_singleIssue.user}')),
      DataCell(Text('${_singleIssue.state}')),
    ]);
    throw UnimplementedError();
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => throw UnimplementedError();

  @override
  // TODO: implement rowCount
  int get rowCount => throw UnimplementedError();

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => throw UnimplementedError();
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loaded = false;
  int _rowPer = 10;
  TableSource _tableSource = TableSource([]);

  Future<List<GithubAPIMain>> fetchIssues(String source) async {
    var url = Uri.parse(source);
    var reponse = await http.get(url);
    List<GithubAPIMain> issues = <GithubAPIMain>[];

    if (reponse.statusCode == 200) {
      var ogJson = jsonDecode(reponse.body);
      for (var ogJson in ogJson) {
        issues.add(GithubAPIMain.fromJson(ogJson));
      }
    }

    return issues;
  }

  Future<void> _retrieveJson() async {
    final fetch = await fetchIssues(
        'https://api.github.com/repos/walmartlabs/thorax/issues');
    if (!loaded) {
      setState(() {
        _tableSource = TableSource(fetch);
        loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _retrieveJson();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: PaginatedDataTable(
            header: Text('Walmart Github Issues'),
            source: _tableSource,
            columns: [
              DataColumn(label: Text('title')),
              DataColumn(label: Text('id')),
              DataColumn(label: Text('user')),
              DataColumn(label: Text('state')),
            ],
            rowsPerPage: _rowPer,
            onRowsPerPageChanged: (int value) {
              setState(() {
                _rowPer = value;
              });
            },
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
