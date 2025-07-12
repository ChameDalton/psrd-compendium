Pathfinder Athenaeum Project Notes
Database Assets

List (from databaselist.txt, commit 2ee2efe):
index.db
book-acg.db, book-apg.db, book-arg.db, book-b1.db, book-b2.db, book-b3.db, book-b4.db, book-cr.db, book-gmg.db, book-ma.db, book-mc.db, book-npc.db, book-oa.db, book-ogl.db, book-pfu.db, book-tech.db, book-uc.db, book-ucampaign.db, book-ue.db, book-um.db
Total: 21 databases, stored in assets/databases/.


User Database (user.db):
Initialized at first startup, stored in getDatabasesPath(), not in assets/databases/.
Used for bookmarks (see user_database.dart, aligns with BookmarkDbAdapter.java).


File Locations:
database_helper.dart: lib/services/database_helper.dart.


Verified: All 21 asset databases exist in assets/databases/. user.db created at startup.
Schema (based on PSRD-Parser database.md):
index.db:
Menu: Menu_id (INTEGER PRIMARY KEY), Parent_menu_id (INTEGER), Name (TEXT), Type (TEXT, nullable), Url (TEXT, nullable), priority (INTEGER)
central_index: Section_id (INTEGER PRIMARY KEY), Name (TEXT), Type (TEXT), Database (TEXT), Parent_id (INTEGER), Search_name (TEXT)


Book Databases (e.g., book-cr.db):
spells: _id (INTEGER PRIMARY KEY), name (TEXT), description (TEXT), full_text (TEXT)
sections: section_id (INTEGER PRIMARY KEY), parent_id (INTEGER), name (TEXT), body (TEXT)


user.db: Bookmarks table (id INTEGER PRIMARY KEY, name TEXT, url TEXT, scroll INTEGER, section_id INTEGER)



Settled Code Issues

BookmarkScreen: Fixed deleteBookmark/addBookmark argument errors (commit 0e1cc7c).
main_test.dart: Fixed import issues (commit 0e1cc7c).
Test Compilation: Removed invalid getDatabase mock (commit dab5c282).
main.dart: Synchronous onGenerateRoute, MainApp state management, fixed _TypeError (commit 2ee2efe).
List Screens: Use central_index queries (Type = 'class', 'creature', etc.).
Navigation: Dynamic menu via Menu table, routes for list/detail screens.
Imports: database_helper.dart is in lib/services/ (commit 2ee2efe).
Dependencies:
Updated mockito to ^5.4.4 due to version resolution failure with ^6.0.0 (commit 5129bb9).
Updated vm_service to 15.0.0 to resolve conflict with flutter_test pinning (commit 8701282).
Updated vector_math to 2.1.4 to resolve conflict with flutter_test pinning (commit TBD).
Updated test_api to 0.7.4 to resolve conflict with flutter_test pinning (commit TBD).
Updated meta to 1.16.0 to resolve conflict with flutter_test pinning (commit TBD).


Compilation Errors (commit 5129bb9):
Fixed main.dart: Removed incorrect userDb parameter, used dbWrangler for HomeScreen.
Fixed database_helper.dart: Replaced DefaultAssetBundle.of(PlatformDispatcher.instance.views.first) with rootBundle for asset loading.
Fixed test files: Used mockDbHelper.closeDatabase() instead of DatabaseHelper().closeDatabase() in tearDown.
Updated pubspec.yaml: Added latest compatible dependency versions (e.g., analyzer: ^7.5.6).
Cleaned test/mocks/database_helper.dart: Removed unused imports (sqflite, database_helper.mocks.dart).



Known Issues (Commit 8701282)

Resolved: vm_service dependency conflict with flutter_test by setting vm_service: 15.0.0.
Resolved: vector_math dependency conflict with flutter_test by setting vector_math: 2.1.4.
Resolved: test_api dependency conflict with flutter_test by setting test_api: 0.7.4.
Resolved: meta dependency conflict with flutter_test by setting meta: 1.16.0.

Next Steps

Verify dependency resolution with updated pubspec.yaml.
Run flutter analyze and flutter test --verbose to confirm compilation and test success.
Implement search screen using central_index.Search_name.
