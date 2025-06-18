# 🎨 Pathfinder Athenaeum `/render/` Module Overview

The `/render/` package provides the presentation and data enrichment layer for structured reference content in Pathfinder Athenaeum. It transforms normalized database entries into **either visual HTML statblocks** or **structured JSON objects**—depending on consumer needs.

---

## 📂 Folder Structure

render/ ├── html/ │ └── [Statblock-style HTML renderers] ├── json/ │ └── [Schema-driven JSON renderers]



---

## 🧱 Architecture Summary

| Layer         | Purpose                                        | Output         |
|---------------|------------------------------------------------|----------------|
| `html/`       | Constructs statblock-style HTML fragments      | `<div>`, `<h2>` |
| `json/`       | Enriches section metadata as typed JSON        | `Map<String, Object>` |
| Shared Entry  | `section.type` determines which renderer to use |               |

---

## ✨ `render/html/` Layer

### 📌 Goal:
Convert a section’s content into a **Pathfinder-formatted HTML view**, mimicking books like the *Bestiary*, *Ultimate Campaign*, etc.

### 🔧 Key Traits:
- Inherits from `HtmlRenderer` or `StatBlockRenderer`
- Uses `renderTitle`, `renderDetails`, `renderFooter`, `renderHeader`
- Selectively structured with tags: `<b>`, `<i>`, `<br>`, etc.
- Relies on `HtmlRenderer.renderDescription()` and `renderBody()` for core content

### 🧩 Highlights:

| Renderer            | Summary                               |
|---------------------|----------------------------------------|
| `CreatureRenderer`  | Bestiary-style monsters                |
| `SettlementRenderer`| Urban statblocks (economy, society)   |
| `VehicleRenderer`   | Modular vehicle data (crew, speed)     |
| `TableRenderer`     | Pass-through, no title/footer/header   |
| `SkillRenderer`     | Title, governing stat, special traits  |
| `StatBlockRenderer` | Provides `addField()`, `renderBreaker()` helpers |

---

## 📘 `render/json/` Layer

### 📌 Goal:
Transform a section into a **typed, schema-aware `JSONObject`**, ready for API response, data sync, or Flutter/Dart rendering.

### 🔧 Key Traits:
- Inherits from `JsonRenderer`
- Each type’s renderer adds specific fields
- Core values (e.g. `name`, `description`, `url`) provided by `SectionRenderer`
- Recursive nesting of children in `sections[]`

### 🧩 Renderer Highlights:

| Renderer              | Enrichments Added                                 |
|-----------------------|----------------------------------------------------|
| `CreatureRenderer`    | Full statblock + `"spells"` object                 |
| `FeatRenderer`        | `"feat_types"` array                              |
| `ItemRenderer`        | `"price"`, `"aura"`, plus `"misc"` array          |
| `TalentRenderer`      | Kineticist-style mechanics                         |
| `SettlementRenderer`  | Government, items, corruption, spellcasting       |
| `SkillRenderer`       | `attribute`, `armor_check_penalty`, `trained_only` |
| `ResourceRenderer`    | `"benefit"` (typoed as `"bebefit"` in code)       |
| `LinkRenderer`        | `"display"` and `"link_url"`                      |
| `JsonRenderer` (base) | `addField(...)` utility                           |

---

## 🔁 Recursive Renderer

### 🗂 `SectionRenderer.java`

This is the **core entry point** to the rendering engine.

#### Responsibilities:
- Converts raw DB cursor into a section object
- Appends base fields: `type`, `name`, `url`, `description`, etc.
- Delegates type-specific enrichments via `getRenderer(type)`
- Adds recursively rendered child sections into `"sections"` array

---

## 🛡 Patterns & Design Observations

| Design Insight     | Description                                  |
|--------------------|----------------------------------------------|
| `type`-based dispatch | All rendering is keyed off `section.type` |
| Fail-safe rendering | Unknown types fall back to `NoOpRenderer`   |
| DRY inheritance    | Abstract base classes provide null guards and boilerplate removal |
| Separation of concerns | DB read ↔️ render output strictly separated |

---

## 🧰 Suggested Enhancements

| Opportunity        | Description                                  |
|--------------------|----------------------------------------------|
| Renderer Registry  | Replace `if–else` in `getRenderer` with a static map |
| Field Normalization| Revisit key names like `"bebefit"` typo      |
| JSON Schema Output | Emit `section.json` exports per type for validation/testing |
| Dart Integration   | Mirror JSON models as Dart classes in Flutter front-end |

---

## ✅ Conclusion

The `/render/` module forms a cohesive dual-output rendering framework, powering both:
- In-app WebView HTML statblocks (`html/`)
- API/Flutter-ready structured data models (`json/`)

It embodies Pathfinder Athenaeum's modular data-first philosophy—blending structure, flexibility, and presentation into one elegant system.




