import 'package:sqflite/sqflite.dart';

class UserDatabase {
  final Database _database;

  UserDatabase(this._database);

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    return await _database.query('bookmarks');
  }

  Future<void> addBookmark(String url, String name) async {
    await _database.insert('bookmarks', {'url': url, 'name': name});
  }

  Future<void> removeBookmark(String url) async {
    await _database.delete('bookmarks', where: 'url = ?', whereArgs: [url]);
  }
}