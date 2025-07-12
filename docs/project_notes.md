# Pathfinder Athenaeum Project Notes

## Database Assets
- **List** (from databaselist.txt, commit dab5c282):
  - index.db
  - book-acg.db, book-apg.db, book-arg.db, book-b1.db, book-b2.db, book-b3.db, book-b4.db, book-cr.db, book-gmg.db, book-ma.db, book-mc.db, book-npc.db, book-oa.db, book-ogl.db, book-pfu.db, book-tech.db, book-uc.db, book-ucampaign.db, book-ue.db, book-um.db
  - **Total**: 21 databases, stored in `assets/databases/`.
- **User Database (user.db)**:
  - Initialized at first startup, stored in `getDatabasesPath()`, not in `assets/databases/`.
  - Used for bookmarks (see user_database.dart, aligns with BookmarkDbAdapter.java).
- **Verified**: All 21 asset databases initialized successfully (flutter run log, commit dab5c282).
- **Schema** (based on PSRD-Parser database.md):
  - **index.db**:
    - `Menu`: Menu_id (INTEGER PRIMARY KEY), Parent_menu_id (INTEGER), Name (TEXT), Type (TEXT), Url (TEXT, nullable), priority (INTEGER)
    - `central_index`: Section_id (INTEGER PRIMARY KEY), Name (TEXT), Type (TEXT), Database (TEXT), Parent_id (INTEGER), Search_name (TEXT)
  - **Book Databases** (e.g., book-cr.db):
    - `spells`: _id (INTEGER PRIMARY KEY), name (TEXT), description (TEXT), full_text (TEXT)
    - `sections`: section_id (INTEGER PRIMARY KEY), parent_id (INTEGER), name (TEXT), body (TEXT)
  - **user.db**: Bookmarks table (id INTEGER PRIMARY KEY, name TEXT, url TEXT, scroll INTEGER, section_id INTEGER)

## Settled Code Issues
- **BookmarkScreen**: Fixed deleteBookmark/addBookmark argument errors (commit 0e1cc7c).
- **main_test.dart**: Fixed import issues (commit 0e1cc7c).
- **Test Compilation**: Removed invalid getDatabase mock (commit dab5c282).
- **main.dart**: Synchronous onGenerateRoute, MainApp state management (commit dab5c282).
- **List Screens**: ClassListScreen, CreatureListScreen, FeatListScreen, RaceListScreen, SpellListScreen use central_index queries (Type = 'class', 'creature', etc.).
- **Navigation**: Dynamic menu via Menu table, routes for list/detail screens (main.dart).

## Known Issues (Commit dab5c282)
- **Test Timeouts**: All tests timeout after 10 minutes (flutter test output).
- **_TypeError**: `type 'Null' is not a subtype of type 'String'` in main.dart:179:45 (HomeScreen._buildMenuItem).
- **Performance**: Frame skips during database initialization (flutter run log).

## Next Steps
- Fix _TypeError in main.dart with null checks for Menu.Url.
- Resolve test timeouts with proper mocking and cleanup.
- Optimize DbWrangler.initializeDatabases with compute.
- Plan search screen using central_index.Search_name.