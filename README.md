# CATIA brake pedal project

This repository contains the complete unpacked CATIA V5 brake-pedal project handoff plus automation for Presentation 05 and Presentation 06.

## One-click completion on the CATIA Windows machine

Double-click:

`COMPLETE_PROJECT.bat`

The runner:

1. starts CATIA V5 automatically when possible,
2. fixes live-part internal PartNumbers,
3. repairs `Pedal_Body.CATPart` to reference-equivalent geometry while preserving the original live model as a backup,
4. generates `Brake_Pedal_Assembly_05.CATProduct`,
5. generates the full Presentation 06 `Brake_Pedal_Assembly.CATProduct` with the required 45 BOM instances,
6. validates parts/update state/BOM counts,
7. creates `Brake_Pedal_Assembly_Submission.zip`.

Generated reports and screenshots are written to `review/`.

## Main outputs

- `Brake_Pedal_Assembly_05.CATProduct` — Presentation 05 assembly.
- `Brake_Pedal_Assembly.CATProduct` — Presentation 06 final assembly.
- `Brake_Pedal_Assembly_Submission.zip` — packaged native deliverables and dependencies.
- `review/final_validation_report.txt` — structural/update/BOM validation.
- `review/task05_report.txt` and `review/task06_report.txt` — assembly-build reports.
- `review/Task05_Assembly.bmp` and `review/Task06_Assembly.bmp` — generated assembly captures.

## Source structure

- `final_parts/` — latest native live parts.
- `parts/` — imported OEM reference models and Tilton native dependencies.
- `reference_parts/` — supplied STEP reference models.
- `source_copies/` — preserved original work.
- `review/` — tutorial extracts/images, CATIA automation, inspection geometry and reports.
- `live_parts/` and `editable_parts/` — superseded intermediate attempts retained for traceability.

## Presentation 06 BOM

The final assembly builder inserts all 45 required component instances, organized into frame, pivot, Tilton/hydraulics, reservoir, foot-plate, shaft and mounting subproducts.

## Important execution note

Native `.CATPart` and `.CATProduct` generation occurs inside CATIA V5 through its Windows COM/CATScript automation interface. The repository contains the completed automation, but the final native outputs are created when `COMPLETE_PROJECT.bat` is run on the Windows computer where CATIA is installed.

After the automated validation passes, visually inspect the final assembly once in CATIA before external submission, especially for clashes and presentation orientation.

See `HANDOFF_FOR_CHATGPT.md` for recovered dimensions, placement derivations and methodology notes.
