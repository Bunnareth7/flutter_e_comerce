import 'package:sqflite/sqflite.dart';
import '../models/search_history_model.dart';

abstract class SearchHistoryLocalDataSource {
  Future<List<SearchHistoryModel>> getRecentSearches({int limit = 10});
  Future<void> addSearch(String query);
  Future<void> clearHistory();
}

class SearchHistoryLocalDataSourceImpl implements SearchHistoryLocalDataSource {
  final Database database;

  SearchHistoryLocalDataSourceImpl({required this.database});

  @override
  Future<List<SearchHistoryModel>> getRecentSearches({int limit = 10}) async {
    final maps = await database.query(
      'search_history',
      orderBy: 'timestamp DESC',
      limit: limit,
    );
    return maps.map((e) => SearchHistoryModel.fromJson(e)).toList();
  }

  @override
  Future<void> addSearch(String query) async {
    // Remove duplicate first
    await database.delete(
      'search_history',
      where: 'query = ?',
      whereArgs: [query],
    );
    // Insert new
    await database.insert('search_history', {
      'query': query,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> clearHistory() async {
    await database.delete('search_history');
  }
}