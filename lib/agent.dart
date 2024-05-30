import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detailagents.dart';

class AgentsPage extends StatefulWidget {
  @override
  _AgentsPageState createState() => _AgentsPageState();
}

class _AgentsPageState extends State<AgentsPage> {
  List agents = [];

  @override
  void initState() {
    super.initState();
    fetchAgents();
  }

  fetchAgents() async {
    final response = await http.get(Uri.parse('https://valorant-api.com/v1/agents'));
    if (response.statusCode == 200) {
      setState(() {
        agents = json.decode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load agents');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agents'),
      ),
      body: agents.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: agents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                    agents[index]['displayIcon'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(agents[index]['displayName']),
                  subtitle: Text(agents[index]['description']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailAgentPage(uuid: agents[index]['uuid']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
