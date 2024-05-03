import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;

class AboutScreen extends StatelessWidget {
  final String url = 'https://github.com/mxstbr/markdown-test-file/blob/master/TEST.md'; // Reemplaza con tu URL

  Future<String> fetchMarkdown() async {
    var url = Uri.parse('https://raw.githubusercontent.com/telmomm/tayma_app/main/aboutme.md');
    
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
            return Markdown(data: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}