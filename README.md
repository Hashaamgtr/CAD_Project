# CATIA brake pedal project — work in progress

Start with [HANDOFF_FOR_CHATGPT.md](HANDOFF_FOR_CHATGPT.md).

Presentation 5 is **not complete**: an assembly-building macro is prepared but has not been run or verified.
Presentation 6 is **not complete**: editable parts and imported OEM parts are prepared; the pedal needs geometric corrections, and the full assembly is still missing.

- `final_parts/`: latest saved native parts, not a certified final submission.
- `parts/`: imported OEM reference models and their native CATIA dependencies. `MC_Inlet.CATPart` here is an obsolete incomplete draft.
- `reference_parts/`: supplied STEP reference models.
- `source_copies/`: copies of the user's original work.
- `review/`: tutorial extracts/images, macros, diagnostic logs, inspection exports, and source integrity records.
- `live_parts/` and `editable_parts/`: superseded intermediate attempts, retained for the requested complete handoff.

Work was done in CATIA V5 B21 (32-bit) on Windows. Native CATIA is required to update and validate CATPart/CATProduct files. Some files/macros contain absolute paths and require relocation before use elsewhere.

The original EFORCE and tutorial files were not modified; SHA-256 checks are recorded in `review/source_integrity_verified.json`.
