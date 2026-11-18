import 'package:flutter/material.dart';
import 'package:shared/shared.dart';


class AdminDonorRecordsScreen extends StatefulWidget {
  const AdminDonorRecordsScreen({super.key});

  @override
  State<AdminDonorRecordsScreen> createState() =>
      _AdminDonorRecordsScreenState();
}

class _AdminDonorRecordsScreenState extends State<AdminDonorRecordsScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
  final response = await ApiClient.get(ApiConstants.adminDonorApplications);
  if (response['success'] != true) {
    throw ApiException(response['message'] ?? 'Failed to load applications');
  }
  return (response['applications'] as List).cast<Map<String, dynamic>>();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor Applications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _future = _load()),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.hasError) {
            final e = snap.error;
            return Center(child: Text(e is ApiException ? e.message : '$e'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final rows = snap.data!;
          if (rows.isEmpty) {
            return const Center(child: Text('No applications yet'));
          }
          return ListView.separated(
            itemCount: rows.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final answers =
                  (rows[i]['answers'] as List).cast<Map<String, dynamic>>();
              return ListTile(
                title: Text('${answers.first['value']}'),
                subtitle: Text(
                  answers
                      .skip(1)
                      .map((a) => '${a['label']}: ${a['value']}')
                      .join('\n'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}