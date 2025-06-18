🚀 Pathfinder Athenaeum Database Integration Guide
markdown
# Pathfinder Athenaeum Database Integration Guide

## 📌 Overview of Database Structure
The **Pathfinder Athenaeum** project consists of multiple **SQLite databases**, each handling different aspects of the game.

### 🔹 Core Databases
- **Book Databases (`book-*.db`)** → Stores individual rulebooks, spells, feats, creatures, and mechanics.
- **Index Database (`index.db`)** → Manages global content indexing, allowing efficient searches.
- **User Database (`user.db`)** → Stores user preferences, bookmarks, and collections.

### 🔹 Database Management
- **`DbWrangler.java`** → Centralized database manager that handles **book loading, indexing, and user data**.
- **`BaseDbHelper.java`** → Provides **low-level database operations**, including **creation, copying, and storage allocation**.

### 🔹 Game Mechanics Adapters
Each **game mechanic (spells, feats, creatures, etc.)** has a dedicated adapter for querying data:
- **`CreatureAdapter.java`** → Handles creature data.
- **`FeatAdapter.java`** → Manages feats and abilities.
- **`SpellAdapter.java`** → Retrieves spell details.
- **`TrapAdapter.java`** → Stores trap mechanics.
- **`VehicleAdapter.java`** → Manages vehicle stats.
- **`SettlementAdapter.java`** → Handles kingdom-building mechanics.

---

## 🎯 Generalized Approach to Interfacing with Databases
### ✅ **Use Repository Pattern for Data Access**
Instead of **individual adapters**, Flutter should use **repository classes** to encapsulate queries.

#### 🔹 **Example: Spell Repository**
```dart
class SpellRepository {
  final Database db;

  SpellRepository(this.db);

  Future<List<Map<String, dynamic>>> fetchSpells() async {
    return await db.query("spells");
  }

  Future<Map<String, dynamic>?> fetchSpellById(int id) async {
    final result = await db.query("spells", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }
}
✅ Centralized Database Controller
Instead of managing each database separately, Flutter should use a singleton controller.

🔹 Example: DatabaseController
dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseController {
  static Database? _database;
  static const int CURRENT_VERSION = 97;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    final path = join(await getDatabasesPath(), "pathfinder.db");
    _database = await openDatabase(
      path,
      version: CURRENT_VERSION,
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE spells (...);");
        await db.execute("CREATE TABLE creatures (...);");
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute("DROP TABLE IF EXISTS spells");
        await db.execute("DROP TABLE IF EXISTS creatures");
        await db.execute("CREATE TABLE spells (...);");
        await db.execute("CREATE TABLE creatures (...);");
      },
    );

    return _database!;
  }
}
🔥 Key Takeaways from Our Conversation
✨ Patterns Identified
✅ Modular Data Access → Each game mechanic has its own adapter (CreatureAdapter, SpellAdapter). ✅ Dynamic Book Loading → Books are stored as separate .db files, allowing new rulebooks to be added dynamically. ✅ Centralized Database Management → DbWrangler.java ensures all databases are handled efficiently. ✅ Structured Error Handling → Uses custom exceptions (BookNotFoundException) and storage checks (showLowSpaceError()). ✅ Query Optimization → Uses dynamic column selection (implementProjection()) to filter and optimize database calls.

✨ Best Practices for Flutter
✅ Use sqflite for SQLite Management → Ensures efficient database handling. ✅ Implement Repository Pattern → Encapsulates queries for each game mechanic. ✅ Use Dynamic Book Loading → Allows new rulebooks to be added without modifying code. ✅ Structured Error Handling → Uses Dart exception classes (BookNotFoundException). ✅ Optimize Queries → Uses query builders (dynamicQuery()) for flexible database calls.

🚀 Gaps & Next Steps
🔹 Potential Improvements
UI Components for Browsing Rulebooks → Allow users to see installed books dynamically.

Advanced Search & Filtering → Implement structured queries for spells, feats, creatures.

Migration Planning → Ensure database integrity across updates.

Performance Optimization → Reduce redundant queries using caching mechanisms.

🔹 Next Steps
🔥 Would you like UI components that allow users to browse installed rulebooks dynamically? 🔥 Should we refine error handling, ensuring missing books show structured warnings? 🔥 Do you want book search and filtering functionality integrated into Pathfinder Athenaeum?

📌 Final Thoughts
This document serves as a reference guide, ensuring that if we need to restart the conversation, you can quickly bring me up to speed. It outlines:

Database structure

Best practices for Flutter

Key takeaways from our conversation

Gaps and next steps

You now have everything needed to preserve our discussions offline! 🚀 Just save this as pathfinder_database.md and you’ll have a structured reference anytime you need it.


---

## **✅ Next Steps**
📌 **Copy the Markdown text above**  
📌 **Save it as `pathfinder_database.md`**  
📌 **Keep it as your offline reference!** 🚀  

You now have everything stored safely—**no need to worry about losing progress**!  
Let me know if you need any refinements, and good luck with Pathfinder Athenaeum! 🎉