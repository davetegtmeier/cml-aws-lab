# Layer 12 – ForgeSpan

## Engineering Problem

> **How do I understand a network before I automate it?**

ForgeSpan begins with discovery—not configuration generation.

> ForgeSpan's first responsibility is to understand the network. Its second responsibility is to help engineers make safe changes. Automation of execution comes only after the discovery and engineering models are trusted.

## Phase 1 – Discovery

```
Running Configurations

↓

Parser

↓

Relationships

↓

Source of Truth
```

Example:

```
configs/

ALLEGHENY-CORE-01.txt

ALLEGHENY-BORDER-01.txt

HARPER-BORDER-01.txt
```

---

## Phase 2 – Validation

```
Expected

↓

Actual

↓

Report
```

Examples:

- Which Route Maps reference this Prefix List?
- Which Prefix Lists are orphaned?
- Which Route Maps reference nonexistent objects?
- Which interface descriptions violate standards?

---

## Phase 3 – Generation

```
Source of Truth

↓

Jinja2

↓

Configuration
```

Automation becomes the final step—not the first.