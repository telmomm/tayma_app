import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;

class LegalAdviseScreen extends StatefulWidget {
  @override
  _LegalAdviseScreenState createState() => _LegalAdviseScreenState();
}

class _LegalAdviseScreenState extends State<LegalAdviseScreen> {
 final String url = 'https://raw.githubusercontent.com/telmomm/tayma_app/main/docs/app/AboutMe.md'; 
  bool _isSwitched = true; 

  Future<String> fetchMarkdown() async {
    var url = Uri.parse('https://raw.githubusercontent.com/telmomm/tayma_app/main/docs/app/AboutMe.md');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load markdown with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load markdown: $e');
    }
  }

  Future<String> OLDfetchMarkdown() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load markdown');
      }
    } catch (e) {
      throw Exception('Failed to load markdown: $e');
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Aviso Legal'),
    ),
    body: FutureBuilder<String>(
      future: fetchMarkdown(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              Expanded(
                child: Markdown(data: snapshot.data!),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Switch(
                    value: _isSwitched,
                    onChanged: (value) {
                      setState(() {
                        _isSwitched = value;
                      });
                    },
                  ),
                  Text('ACEPTAR AVISO LEGAL', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return CircularProgressIndicator();
      },
    ),
  );
}

}