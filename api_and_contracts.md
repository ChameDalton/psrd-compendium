# 🔧 Pathfinder Athenaeum API and Contracts Modernization Guide

This document provides an architectural breakdown and Flutter migration mapping for all classes within the `api/` and `contracts/` folders. These layers together serve as the **Java-based content interface and symbolic routing system**, which will be translated into a **modular Dart service layer**.

---

## 📦 Structure Overview

### 📁 `api/`
Contains content provider classes that expose indexed content from the database via URI-based query and rendering endpoints.

### 📁 `contracts/`
Defines symbolic constants, MIME types, URI authorities, and column schemas used across the `api/` layer.

---

## 🚀 `api/` Layer Summary

| Class                     | Purpose                                               | Primary Query Source                             |
|---------------------------|-------------------------------------------------------|--------------------------------------------------|
| `AbstractContentProvider` | Base class for URI streaming and content rendering    | Book/Index databases, HtmlRenderFarm, JSON tools |
| `CasterContentProvider`   | Exposes a list of casters                             | `ApiCasterListAdapter`                           |
| `CreatureContentProvider` | Query and render creature entries                     | `ApiCreatureListAdapter`                         |
| `FeatContentProvider`     | Provides feat list and rendered content               | `ApiFeatListAdapter`                             |
| `SectionContentProvider`  | Lists class sections via section adapter              | `ApiClassListAdapter`                            |
| `SkillContentProvider`    | Lists skills and streams individual entries           | `ApiSkillListAdapter`                            |
| `SpellContentProvider`    | Complex spell routing and class-filtered endpoints    | Multiple spell list adapters                     |

> **Rendering Support:** All providers inherit file streaming and JSON/HTML rendering from `AbstractContentProvider`.

---

## 📋 Migration Plan for `api/`

Replace `ContentProvider` subclasses with **Dart service classes** like:

```dart
class SpellService {
  Future<List<Spell>> fetchAllSpells();
  Future<List<Spell>> fetchFilteredSpells();
  Future<List<Spell>> fetchSpellsByClass(String classId);
  Future<Map<String, dynamic>> renderSpellJson(int spellId);
}
