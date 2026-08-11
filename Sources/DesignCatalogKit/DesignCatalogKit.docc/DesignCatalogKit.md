# ``DesignCatalogKit``

Put several brands' design systems side by side and read what differs.

## Overview

DesignCatalogKit is instrumentation. Each brand registers a ``CatalogEntry`` describing one
component, tagged with an *archetype* — the comparison axis, such as `FormControl` or
`Card`. Grouping entries by archetype puts every brand's answer to the same problem next to
every other brand's, which is the only arrangement in which a difference in approach is
visible rather than merely present.

An entry carries a ``DesignAnnotation`` alongside the view. Recording *why* a design works,
not just what it looks like, is what makes the catalog useful months later when the
screenshot no longer explains itself.

```swift
let entry = CatalogEntry(
    id: "acme-form-control",
    brandName: "Acme",
    archetype: "FormControl",
    title: "Acme form control",
    annotation: DesignAnnotation(
        purpose: "The standard pattern for form input",
        whyItWorks: "Consistent label position and error placement raise completion rates"
    ),
    theme: AcmeTheme()
) {
    DSTextField("Name", text: .constant("Ada Lovelace"))
}

let grouped = entries.groupedByArchetype()
```

Each entry renders under its own theme, so a gallery shows brands as they actually look
rather than as they would look recolored.

``TokenDiff`` compares two themes' token sets directly. `differing(_:)` filters the result
to rows that actually disagree, which is usually the only part worth reading:

```swift
let rows = TokenDiff.typography(themeA.typographyScale, themeB.typographyScale)
let interesting = TokenDiff.differing(rows)
```

## Topics

### Entry model

- ``CatalogEntry``
- ``DesignAnnotation``

### Views

- ``CatalogEntryCard``
- ``CatalogGalleryView``
- ``CatalogCompareView``
- ``ThemedEntryView``

### Token diffing

- ``TokenDiff``
- ``TokenDiffView``
