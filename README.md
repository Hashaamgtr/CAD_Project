# CATIA brake pedal project

This repository contains the unpacked CATIA V5 brake-pedal project handoff.

Start with:
- [COMPLETION_STATUS.md](COMPLETION_STATUS.md) — exact current status and remaining CATIA-only work.
- [HANDOFF_FOR_CHATGPT.md](HANDOFF_FOR_CHATGPT.md) — measured geometry, placement hypotheses, bill of materials and CATIA automation notes.
- [RUN_FINALIZE.bat](RUN_FINALIZE.bat) — one-click runner for the safe automated CATIA steps.

## Main folders

- `final_parts/` — latest native live parts.
- `parts/` — imported OEM reference models and native Tilton dependencies.
- `reference_parts/` — supplied STEP reference models.
- `source_copies/` — preserved copies of the original work.
- `review/` — tutorial extracts/images, CATScript/VBScript automation, logs, diagnostic exports and validation tools.
- `live_parts/` and `editable_parts/` — superseded intermediate attempts kept for traceability.

## Important status

Presentation 05 has an assembly-building macro at `review/assemble05.CATScript`, but the resulting native assembly must still be generated and validated in CATIA V5.

Presentation 06 is not yet a certified finished submission. The principal blocker is `final_parts/Pedal_Body.CATPart`, whose live geometry is approximately 6.15% below the supplied reference volume because reinforcement/relief details remain incomplete. The final 45-instance assembly must then be built and validated in CATIA.

The latest live-part builder now sets correct internal CATIA `PartNumber` values. Existing generated files can be fixed with `review/finalize_part_numbers.CATScript`.

CATIA V5 B21 (32-bit) on Windows is required to execute the native automation and validate `.CATPart` / `.CATProduct` results.