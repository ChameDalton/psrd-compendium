# 🛠 Pathfinder Athenaeum `/utils/` Module Overview

The `/utils/` package provides low-level utility classes that support system infrastructure, URL mapping, and disk space safeguards across the app. These helpers offer reusable, Android-aware logic that complements the `api/`, `db/`, and `render/` modules.

---

## 📦 Overview of Utilities

| Class                  | Role                                               |
|------------------------|----------------------------------------------------|
| `AvailableSpaceHandler`| Queries free space on internal/external storage    |
| `LimitedSpaceException`| Signals insufficient space errors (with size hint) |
| `UrlAliaser`           | Resolves virtual PFSRD-style URLs into canonical ones using the index database |

---

## 🧰 Class-by-Class Breakdown

### `AvailableSpaceHandler`
> Static utility for checking remaining disk space

- Provides disk space in **bytes**, **KB**, **MB**, or **GB**
- Returns block counts via `StatFs`
- Uses Android’s environment constants:
  - `Environment.getDataDirectory()` → internal
  - `Environment.getExternalStorageDirectory()` → SD card / emulated external
- Constants:
  ```java
  SIZE_KB = 1024
  SIZE_MB = 1024 * 1024
  SIZE_GB = 1024 * 1024 * 1024
