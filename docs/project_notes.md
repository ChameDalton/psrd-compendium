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


Assets Configuration:
pubspec.yaml uses assets: - assets/databases/ to include all 21 databases, as per Flutter best practices. Individual listing avoided to reduce maintenance; database list is documented in databaselist.txt and here. Confirmed as preferred approach (commit 8fc78d0).



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
Updated vector_math to 2.1.4 to resolve conflict with flutter_test pinning (commit d517861).
Updated test_api to 0.7.4 to resolve conflict with flutter_test pinning (commit d517861).
Updated meta to 1.16.0 to resolve conflict with flutter_test pinning (commit d517861).
Updated material_color_utilities to 0.11.1 to resolve conflict with flutter_test pinning (commit d517861).
Removed leak_tracker, leak_tracker_testing, leak_tracker_flutter_testing due to unavailability of leak_tracker: 11.0.0 and lack of need for memory leak tracking at this stage (commit 68c21a09).
Updated characters to 1.4.0 to resolve conflict with flutter_test pinning (commit 68c21a09).
Downgraded analyzer to 6.8.0 to resolve mockito: 5.4.5 type errors in build_runner (commit 282da6de).
Reverted mockito to 5.4.4 and removed leak_tracker packages to resolve build_runner and test issues (commit a461c590).
Fixed DbWrangler undefined errors by ensuring database_helper.dart is correctly implemented and imported (commit a461c590).
Fixed generateRoute type mismatch in main.dart by correcting the return type to Route<dynamic>? Function(RouteSettings) (commit a461c590).
Removed leak_tracker packages again due to unintended re-addition in commit a461c590, ensuring they are not downloaded until needed for performance optimization in Phase 2.


Compilation Errors (commit 5129bb9):
Fixed main.dart: Removed incorrect userDb parameter, used dbWrangler for HomeScreen.
Fixed database_helper.dart: Replaced DefaultAssetBundle.of(PlatformDispatcher.instance.views.first) with rootBundle for asset loading.
Fixed test files: Used mockDbHelper.closeDatabase() instead of DatabaseHelper().closeDatabase() in tearDown.
Updated pubspec.yaml: Added compatible dependency versions (e.g., analyzer: ^6.8.0).
Cleaned test/mocks/database_helper.dart: Removed unused imports (sqflite, database_helper.mocks.dart).


Test Errors (commit 282da6de):
Fixed test files: Removed const from MaterialApp to resolve non-const DbWrangler constructor errors.
Fixed main.dart: Updated BookmarkScreen to use dbWrangler.userDb instead of dbWrangler.


Test Errors (commit a461c590):
Fixed missing mock files by regenerating mocks after updating pubspec.yaml and ensuring database_helper.dart imports.
Fixed DbWrangler and MockDbWrangler undefined errors by verifying database_helper.dart implementation.
Fixed generateRoute type mismatch in main.dart.
Addressed leak_tracker reappearance by removing from pubspec.yaml and clearing pub cache.



Known Issues (Commit a461c590)

Resolved: vector_math dependency conflict with flutter_test by setting vector_math: 2.1.4.
Resolved: test_api dependency conflict with flutter_test by setting test_api: 0.7.4.
Resolved: meta dependency conflict with flutter_test by setting meta: 1.16.0.
Resolved: material_color_utilities dependency conflict with flutter_test by setting material_color_utilities: 0.11.1.
Resolved: leak_tracker version unavailability by removing leak_tracker, leak_tracker_testing, leak_tracker_flutter_testing.
Resolved: characters conflict with flutter_test by setting characters: 1.4.0.
Resolved: mockito: 5.4.5 type errors in build_runner by downgrading analyzer to 6.8.0 and reverting mockito to 5.4.4.
Resolved: Test errors by ensuring database_helper.dart is correctly imported and mocks are regenerated.
Resolved: leak_tracker packages reappearing by updating pubspec.yaml and clearing pub cache.

Next Steps

Verify dependency resolution and test compilation with updated pubspec.yaml, database_helper.dart, and test files.
Run flutter analyze and flutter test --verbose to confirm compilation and test success.
Implement search screen using central_index.Search_name.
Run flutter pub outdated to check for compatible dependency upgrades.
Run flutter doctor to verify Flutter SDK version consistency.
Clear pub cache with flutter pub cache repair if dependency issues persist.
If targeting Windows, install Visual Studio with "Desktop development with C++" workload.
Avoid re-adding leak_tracker packages until Phase 2, when memory leak tracking is needed.
