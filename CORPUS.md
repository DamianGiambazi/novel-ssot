# CORPUS — how book/ was made

`corpus/ch-01.md … ch-24.md`: one file per chapter, so every search result names exactly one chapter.
`questions/q1.txt … q4.txt`: the four spine questions (see `spine/PREDICTION.md`). They are vectorised in the **same** run as the chapters, by the same model.

## How the corpus was made (the provenance rule)
The corpus is **copied, not written**. Each chapter file holds the story content of the author's draft notes: setting, events, images, dialogue. Writer-only material is removed: labels (`SETTING:`, `PURPOSE:`), pillar/Figure annotations, cross-references ("as in Chapter 1") and production notes. Those would hand the search its answers.

Check (2026-10-18): 227 of 238 sentences appear verbatim in the notes. The other 11 only remove a label or a lead-in, restore a name a label carried ("Her car" → "Sarah's car"), or render the Chapter 7 echo as the thought the notes prescribe.

`chapter-1` remains Read-Only (Leviathan Lock). `ch-01.md` is a copy of its story content, not a rewrite.

## Recipe (what a rebuild needs)
- vector-snake 2.0.0 (available on request), `--max-chars 800 --offline`.
- Embedding model: all-MiniLM-L6-v2, Hugging Face snapshot `1110a243fdf4706b3f48f1d95db1a4f5529b4d41` (recorded from SPOOKY's cache before the seal).
- Line endings: LF everywhere (`.gitattributes`).
