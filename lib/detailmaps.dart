import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class DetailMapPage extends StatefulWidget {
  final String uuid;

  DetailMapPage({required this.uuid});

  @override
  _DetailMapPageState createState() => _DetailMapPageState();
}

class _DetailMapPageState extends State<DetailMapPage> {
  Map map = {};

  @override
  void initState() {
    super.initState();
    fetchMapDetail();
  }

  fetchMapDetail() async {
    final response = await http.get(Uri.parse('https://valorant-api.com/v1/maps/${widget.uuid}'));
    if (response.statusCode == 200) {
      setState(() {
        map = json.decode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load map detail');
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Map Page'),
      ),
      body: map.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Name: ${map['displayName']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('Coordinates: ${map['coordinates']}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('Description: ${map['description']}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  if (map['splash'] != null)
                    Image.network(map['splash']),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _launchURL(map['splash']),
                    child: Text('Open Map detail in Browser'),
                  ),
                ],
              ),
            ),
    );
  }
}