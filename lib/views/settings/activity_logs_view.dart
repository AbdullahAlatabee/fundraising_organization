import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/database/database_helper.dart';
import '../../data/models/activity_log_model.dart';

class ActivityLogsView extends StatelessWidget {
  const ActivityLogsView({Key? key}) : super(key: key);

  Future<List<ActivityLog>> _fetchLogs() async {
    return await DatabaseHelper.instance.getLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Activity Logs')),
      body: FutureBuilder<List<ActivityLog>>(
        future: _fetchLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No activity logs'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final log = snapshot.data![index];
              return ListTile(
                title: Text('${log.action} - ${log.entity}'),
                subtitle: Text('User ID: ${log.userId} | ${log.timestamp}'),
                leading: Icon(Icons.history),
              );
            },
          );
        },
      ),
    );
  }
}
